import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_x_app/core/services/location_service.dart';
import 'package:urban_x_app/features/my_issues/presentation/widgets/add_issue/issue_category_selector.dart';
import 'package:urban_x_app/features/my_issues/presentation/widgets/add_issue/issue_description_field.dart';
import 'package:urban_x_app/features/my_issues/presentation/widgets/add_issue/issue_image_picker.dart';
import 'package:urban_x_app/features/my_issues/presentation/widgets/add_issue/issue_location_preview.dart';
import 'package:urban_x_app/features/my_issues/presentation/widgets/add_issue/issue_submit_button.dart';
import 'package:urban_x_app/shared/widgets/app_main_drawer.dart';
import 'package:urban_x_app/shared/widgets/glass_sliver_app_bar.dart';
import 'package:urban_x_app/features/my_issues/providers/add_issue_provider.dart';

class AddIssuePage extends StatefulWidget {
  const AddIssuePage({super.key});

  @override
  State<AddIssuePage> createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory;
  String? description;
  String? imagePath;
  String? locationText;
  double? latitude;
  double? longitude;
  bool isLoadingLocation = false;
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final addIssueProvider = Provider.of<AddIssueProvider>(context);

    return Scaffold(
      drawer: const AppMainDrawer(),
      body: CustomScrollView(
        slivers: [
          GlassSliverAppBar(
            title: Text(
              "Add Issue",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),

          // 🧾 Main Form Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🖼 Image Picker
                    IssueImagePicker(
                      onImagePicked: (path, mockLocation, predictedLabel) {
                        setState(() {
                          imagePath = path;
                          isImageSelected = path.isNotEmpty;
                          isLoadingLocation = isImageSelected;
                          locationText = null;
                        });

                        if (isImageSelected) {
                          _fetchCurrentLocation();
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // 🧭 Show Location
                    if (isImageSelected)
                      isLoadingLocation
                          ? _buildLocationLoading(context)
                          : locationText != null
                              ? IssueLocationPreview(locationText: locationText!)
                              : const SizedBox(),

                    if (isImageSelected) const SizedBox(height: 20),

                    // 🏷 Category Selector
                    IssueCategorySelector(
                      selectedCategory: selectedCategory,
                      onCategoryChanged: (value) {
                        setState(() => selectedCategory = value);
                      },
                    ),
                    const SizedBox(height: 20),

                    // 📝 Description Field
                    IssueDescriptionField(
                      onChanged: (val) => setState(() {
                        description = val;
                      }),
                    ),
                    const SizedBox(height: 30),

                    // 🚀 Submit Button
                    IssueSubmitButton(
                      onPressed: () => _handleSubmit(addIssueProvider),
                      isLoading: addIssueProvider.isLoading ||
                          addIssueProvider.isSubmitting,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🌍 Automatically fetch current location using LocationService
  Future<void> _fetchCurrentLocation() async {
    try {
      final data = await LocationService.getCurrentLocation();
      setState(() {
        latitude = data['latitude'];
        longitude = data['longitude'];
        locationText = data['address'];
        isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        locationText = e.toString();
        isLoadingLocation = false;
      });
    }
  }

  Widget _buildLocationLoading(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerHighest.withAlpha(40),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(width: 10),
          Text("Fetching location...", style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  /// 🧠 Main Submit Logic
  Future<void> _handleSubmit(AddIssueProvider addIssueProvider) async {
    if (!_formKey.currentState!.validate()) return;
    if (imagePath == null || imagePath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
      return;
    }
    if (locationText == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please wait for location to load.")),
      );
      return;
    }

    _formKey.currentState!.save();

    // ✅ Step 1: Show Verifying Dialog
    _showLoadingDialog("Verifying your request...");

    await addIssueProvider.verifyIssue(
      File(imagePath!),
      description ?? "",
    );

    if (!mounted) return;
    Navigator.pop(context); // Close verifying dialog

    if (addIssueProvider.errorMessage != null) {
      _showErrorDialog("Verification Failed", addIssueProvider.errorMessage!);
      return;
    }

    final verificationResult = addIssueProvider.verificationResult;

    if (verificationResult == null ||
        verificationResult['is_problem'] == false) {
      _showErrorDialog(
        "Not a Valid Issue",
        verificationResult?['reason'] ??
            "AI could not validate this as a civic issue.",
      );
      return;
    }

    // ✅ Step 2: Verified → Show Submitting Dialog
    _showLoadingDialog("Submitting your issue...");

    await addIssueProvider.submitIssue(
      title: verificationResult['title'] ?? "Untitled Issue",
      description: description ?? "",
      category: selectedCategory ?? verificationResult['category'] ?? "Other",
      imageFile: File(imagePath!),
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
    );

    if (!mounted) return;
    Navigator.pop(context); // Close submitting dialog

    if (addIssueProvider.errorMessage != null) {
      _showErrorDialog("Submission Failed", addIssueProvider.errorMessage!);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(addIssueProvider.successMessage ?? "Issue submitted!"),
      ),
    );

    Navigator.pop(context, true);
  }

  /// 🧱 Generic Loading Dialog
  void _showLoadingDialog(String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🚨 Error Dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
