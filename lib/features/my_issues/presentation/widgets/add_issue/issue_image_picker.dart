import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IssueImagePicker extends StatefulWidget {
  final void Function(String path, String? mockLocation, String? predictedLabel)
      onImagePicked;

  const IssueImagePicker({super.key, required this.onImagePicked});

  @override
  State<IssueImagePicker> createState() => _IssueImagePickerState();
}

class _IssueImagePickerState extends State<IssueImagePicker> {
  File? _selectedImage;
  bool _isLoading = false;

  final List<String> _mockLocations = [
    'Wardha Road, Somalwada, Nagpur, Maharashtra 440025',
    'Dharampeth, Nagpur, Maharashtra 440010',
    'Manish Nagar, Nagpur, Maharashtra 440015',
    'Sitabuldi, Nagpur, Maharashtra 440012',
    'Civil Lines, Nagpur, Maharashtra 440001',
    'Pratap Nagar, Nagpur, Maharashtra 440022',
    'Bajaj Nagar, Nagpur, Maharashtra 440010',
  ];

  // Replace this with your backend URL
  static const String _apiBaseUrl = "https://civic-issue-image-classification.onrender.com"; // Local dev server
  // Example for deployed: "https://urbanx-api.vercel.app"

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (pickedFile == null) return;

      setState(() {
        _selectedImage = File(pickedFile.path);
        _isLoading = true;
      });

      // Mock location simulation
      await Future.delayed(const Duration(seconds: 2));
      final random = Random();
      final mockLocation =
          _mockLocations[random.nextInt(_mockLocations.length)];

      // ---- Make API request for image classification ----
      final predictedLabel = await _classifyImage(File(pickedFile.path));

      if (mounted) {
        setState(() => _isLoading = false);
      }

      // Return image, location, and label
      widget.onImagePicked(pickedFile.path, mockLocation, predictedLabel);
    } catch (e) {
      debugPrint("Error picking or classifying image: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${e.toString()}")),
        );
      }
    }
  }

  Future<String?> _classifyImage(File imageFile) async {
    try {
      final uri = Uri.parse("$_apiBaseUrl/classify");

      final request = http.MultipartRequest("POST", uri)
        ..files.add(await http.MultipartFile.fromPath("file", imageFile.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        debugPrint("predictedLabel - $data");
        return data["predicted_label"] ?? "Unknown";
      } else {
        debugPrint("API Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      debugPrint("Error sending request: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.surfaceContainerHighest.withAlpha(40),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_selectedImage == null)
              _buildPlaceholder(context)
            else
              Image.file(_selectedImage!, fit: BoxFit.cover),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            if (_selectedImage != null && !_isLoading)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () {
                      setState(() => _selectedImage = null);
                      widget.onImagePicked('', null, null);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_a_photo_outlined, size: 42, color: color),
          const SizedBox(height: 8),
          Text(
            "Tap to select an image",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
