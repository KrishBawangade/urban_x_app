import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiService {
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  /// Verifies if the image and description represent a valid civic issue.
  /// Returns structured response:
  /// {
  ///   is_problem, category, matches, confidence,
  ///   priority, title, reason
  /// }
  Future<Map<String, dynamic>> verifyImageAndDescription({
    required File imageFile,
    required String description,
  }) async {
    try {
      // 1️⃣ Convert image to base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // 2️⃣ Gemini System Prompt
      final String geminiSystemPrompt = '''
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
5. Assign a *priority* level between 1 and 100 to indicate the urgency and severity of the issue.
   - 80–100 → Critical or immediate attention (e.g., sewage overflow, major road damage, exposed electric pole)
   - 50–79 → Moderate importance (e.g., garbage pile-up, broken streetlight)
   - 20–49 → Low severity or minor inconvenience (e.g., small pothole, mild noise pollution)
   - 1–19  → Very low or negligible concern

   Description - $description

Return your response strictly in this JSON format:
{
  "is_problem": boolean,             // true if it's a real civic issue
  "category": string,                // one of the categories above or "Other"
  "matches": boolean,                // true if image matches the description
  "confidence": number,              // confidence level between 0.0 and 1.0
  "priority": number,                // integer between 1 and 100 (1=low, 100=high)
  "title": string or null,           // short title if is_problem=true, else null
  "reason": string                   // short and clear explanation for your decision
}

Rules:
- Always return a valid JSON object.
- Do NOT include markdown, code fences, or any text outside the JSON.
- The title must be under 8 words.
- Keep the reasoning concise (1–2 sentences).
- If the issue is not real, set title to null.
- Use both image and description context to decide the category, title, and priority accurately.
''';

      // 3️⃣ Build Gemini request body
      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": geminiSystemPrompt},
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Image,
                },
              },
            ],
          },
        ],
      };

      // 4️⃣ Send request to Gemini API
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // 5️⃣ Handle Gemini response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final textOutput =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (textOutput == null) {
          throw Exception('Invalid Gemini response: no text found.');
        }

        debugPrint("🔹 Gemini raw output: $textOutput");

        final parsedJson = extractJsonFromText(textOutput);

        if (parsedJson != null) {
          return {
            "is_problem": parsedJson["is_problem"] ?? false,
            "category": parsedJson["category"] ?? "Other",
            "matches": parsedJson["matches"] ?? false,
            "confidence": parsedJson["confidence"] ?? 0.0,
            "priority": parsedJson["priority"] ?? 0,
            "title": parsedJson["title"],
            "reason": parsedJson["reason"] ?? "No reason provided",
          };
        } else {
          return {
            "is_problem": false,
            "category": "Other",
            "matches": false,
            "confidence": 0.0,
            "priority": 0,
            "title": null,
            "reason": "Unable to parse AI response.",
            "raw_output": textOutput,
          };
        }
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

  /// Extracts JSON from Gemini's text output safely.
  Map<String, dynamic>? extractJsonFromText(String text) {
    try {
      // Remove any ```json or ```text blocks and trim whitespace
      final cleanedText = text
          .replaceAll(RegExp(r'^```[a-zA-Z]*\n?'), '')
          .replaceAll(RegExp(r'\n?```$'), '')
          .trim();

      // Find JSON substring
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
