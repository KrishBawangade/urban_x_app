import 'dart:io';
import 'package:flutter/material.dart';
import 'package:urban_x_app/features/my_issues/services/gemini_service.dart';

class AddIssueProvider extends ChangeNotifier {
  final GeminiApiService _geminiService = GeminiApiService();

  bool _isLoading = false;
  bool _isSubmitting = false;
  Map<String, dynamic>? _verificationResult;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  Map<String, dynamic>? get verificationResult => _verificationResult;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// ✅ Step 1: Verify image & description using Gemini AI
  Future<void> verifyIssue(File imageFile, String description) async {
    _isLoading = true;
    _errorMessage = null;
    _verificationResult = null;
    notifyListeners();

    try {
      final result = await _geminiService.verifyImageAndDescription(
        imageFile: imageFile,
        description: description,
      );
      _verificationResult = result;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ✅ Step 2: Add verified issue to Firestore / backend
  Future<void> submitIssue({
    required String title,
    required String description,
    required String category,
    required File imageFile,
    required double latitude,
    required double longitude,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // TODO: Replace this with your actual Firestore / API logic
      await Future.delayed(const Duration(seconds: 2));

      _successMessage = "Issue successfully submitted!";
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isSubmitting = false;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _isSubmitting = false;
    _errorMessage = null;
    _successMessage = null;
    _verificationResult = null;
    notifyListeners();
  }
}
