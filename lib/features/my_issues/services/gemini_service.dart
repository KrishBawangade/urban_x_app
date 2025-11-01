import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiService {
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
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

      // 2️⃣ Build Gemini request body
      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text":
                    "You are an image verification AI. Analyze whether the description matches the image. "
                        "Return a valid JSON with these fields: "
                        "{matches: true/false, confidence: 0.0–1.0, reason: 'short explanation'}. "
                        "Description: \"$description\""
              },
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Image,
                }
              }
            ]
          }
        ]
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
        final parsedJson = _extractJson(textOutput);
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
            'Gemini API Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error verifying image and description: $e');
      rethrow;
    }
  }

  /// Extracts JSON from Gemini's text output safely
  Map<String, dynamic>? _extractJson(String text) {
    try {
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start != -1 && end != -1) {
        final jsonString = text.substring(start, end + 1);
        return jsonDecode(jsonString);
      }
    } catch (e) {
      debugPrint('⚠️ JSON extraction error: $e');
    }
    return null;
  }
}
