import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  String? imageUrl;
  String? locationText;
  bool isLoadingLocation = false;
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ✅ Provider instance
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
                          imageUrl = path;
                          isImageSelected = path.isNotEmpty;

                          if (mockLocation == null && path.isNotEmpty) {
                            isLoadingLocation = true;
                            locationText = null;
                          } else {
                            isLoadingLocation = false;
                            locationText = mockLocation;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // 🧭 Show Location after image is selected
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
                      onChanged: (val) => description = val,
                    ),
                    const SizedBox(height: 30),

                    // 🚀 Submit Button
                    IssueSubmitButton(
                      onPressed: () => _handleSubmit(addIssueProvider),
                      isLoading: addIssueProvider.isLoading,
                    ),
                    const SizedBox(height: 20),

                    // ⚠️ Error Message
                    if (addIssueProvider.errorMessage != null)
                      Text(
                        addIssueProvider.errorMessage!,
                        style: TextStyle(
                          color: colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    // ✅ Success Result
                    if (addIssueProvider.verificationResult != null)
                      Text(
                        "Verification Successful ✅\n${addIssueProvider.verificationResult}",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
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
          Text(
            "Fetching location...",
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit(AddIssueProvider addIssueProvider) async {
    if (!_formKey.currentState!.validate()) return;
    if (imageUrl == null || imageUrl!.isEmpty) {
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

    // ✅ Use provider to verify image & description
    await addIssueProvider.verifyIssue(File(imageUrl!), description ?? "");

    if (addIssueProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification failed: ${addIssueProvider.errorMessage}")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Issue verified successfully!")),
      );

      // TODO: Firestore or API submission logic after verification success
    }
  }
}
