import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiService {
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  /// Verifies if the description matches the image content.
  /// Returns structured response: { matches, confidence, reason }
  Future<Map<String, dynamic>> verifyImageAndDescription({
    required File imageFile,
    required String description,
  }) async {
    try {
      // 1️⃣ Convert image to base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      String geminiSystemPrompt = '''
You are an AI verifier for a civic issue reporting app named *UrbanX*.
Your job is to evaluate user-submitted reports that include:
1. An image showing a possible civic issue.
2. A short text description written by the user.

You must analyze both the image and description together and determine:
1. Whether the submission truly represents a real civic problem.
2. If valid, classify it into one of these categories:
   ["Road Damage", "Garbage", "Street Light", "Water Leakage", "Sewage Overflow",
    "Illegal Parking", "Noise Pollution", "Air Pollution", "Tree Cutting",
    "Encroachment", "Public Safety", "Drainage", "Animal Issue", "Electric Pole", "Other"]
3. Check whether the description accurately matches what is visible in the image.
4. If the issue is valid (is_problem = true), generate a short, meaningful title (3–8 words)
   summarizing the problem based on both the image and description 
   (e.g., "Broken Streetlight Near Main Road" or "Garbage Overflow Beside Park").

   Description - $description

Return your response strictly in this JSON format:
{
  "is_problem": boolean,             // true if it's a real civic issue
  "category": string,                // one of the categories above or "Other"
  "matches": boolean,                // true if image matches the description
  "confidence": number,              // confidence level between 0.0 and 1.0
  "title": string or null,           // short title if is_problem=true, else null
  "reason": string                   // short and clear explanation for your decision
}

Rules:
- Always return a valid JSON object.
- Do NOT include markdown, code fences, or any text outside the JSON.
- The title must be under 8 words.
- Keep the reasoning concise (1–2 sentences).
- If the issue is not real, set title to null.
- Use the description context to understand the situation better and to generate more accurate titles.
''';

      // 2️⃣ Build Gemini request body
      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": geminiSystemPrompt},
              {
                "inline_data": {"mime_type": "image/jpeg", "data": base64Image},
              },
            ],
          },
        ],
      };

      // 3️⃣ Send request to Gemini API
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // 4️⃣ Handle Gemini response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract the AI’s text output
        final textOutput =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (textOutput == null) {
          throw Exception('Invalid Gemini response: no text found.');
        }

        debugPrint("output: $textOutput");
        // Try to extract JSON from the text output
        final parsedJson = extractJsonFromText(textOutput);
        debugPrint("Parsed json: $parsedJson");

        // Return structured output (fallback to text if parsing fails)
        return parsedJson ??
            {
              "matches": false,
              "confidence": 0.0,
              "reason": "Unable to parse AI response",
              "raw_output": textOutput,
            };
      } else {
        throw Exception(
          'Gemini API Error: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error verifying image and description: $e');
      rethrow;
    }
  }

  /// Extracts JSON from Gemini's text output safely
  Map<String, dynamic>? extractJsonFromText(String text) {
    try {
      // Step 1: Remove code block backticks and language tags like ```json or ```dart
      final cleanedText =
          text
              .replaceAll(RegExp(r'^```[a-zA-Z]*\n?'), '')
              .replaceAll(RegExp(r'\n?```$'), '')
              .trim();

      // Step 2: Extract JSON portion (from first { to last })
      final start = cleanedText.indexOf('{');
      final end = cleanedText.lastIndexOf('}');
      if (start != -1 && end != -1) {
        final jsonString = cleanedText.substring(start, end + 1);
        return jsonDecode(jsonString);
      }
    } catch (e) {
      debugPrint('⚠️ JSON extraction error: $e');
    }
    return null;
  }
}
