import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_export.dart';

/// Diagnostic Center Details Screen with prescription upload and mock AI
class DiagnosticCenterDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> center;

  const DiagnosticCenterDetailsScreen({super.key, required this.center});

  @override
  State<DiagnosticCenterDetailsScreen> createState() =>
      _DiagnosticCenterDetailsScreenState();
}

class _DiagnosticCenterDetailsScreenState
    extends State<DiagnosticCenterDetailsScreen> {
  File? _prescriptionImage;
  bool _isAnalyzing = false;
  String? _aiResult;
  final _picker = ImagePicker();

  Future<void> _uploadPrescription() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _prescriptionImage = File(image.path);
          _isAnalyzing = true;
          _aiResult = null;
        });

        // Simulate AI analysis
        await Future.delayed(const Duration(seconds: 2));

        // Mock AI result
        final hasTests = DateTime.now().millisecond % 2 == 0;
        setState(() {
          _isAnalyzing = false;
          _aiResult = hasTests
              ? '✅ Required tests found:\n• Complete Blood Count (CBC)\n• Lipid Profile\n• Blood Sugar (Fasting)'
              : '❌ No specific tests found in prescription.\nPlease select tests manually.';
        });
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Diagnostic Center'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.center['image'] ?? 'https://via.placeholder.com/400',
                  ),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {},
                ),
                color: theme.primaryColor.withValues(alpha: 0.1),
              ),
              child: widget.center['image'] == null
                  ? Icon(Icons.biotech, size: 80, color: theme.primaryColor)
                  : null,
            ),

            // Center Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.center['name'] ?? 'Unknown Center',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Hyderabad, Telangana • ${widget.center['distance']} km',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.center['rating']} (${widget.center['reviews']} reviews)',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Available Tests
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Tests',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (widget.center['tests'] as List?)?.map((test) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    theme.primaryColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              test,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Price Range
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price Range',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      widget.center['priceRange'] ?? '₹100 - ₹5000',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(),

            // Prescription Upload Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Prescription (Optional)',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload your doctor\'s prescription for AI-powered test recommendations',
                    style:
                        theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Upload Button
                  if (_prescriptionImage == null)
                    OutlinedButton.icon(
                      onPressed: _uploadPrescription,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Choose Prescription Image'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Prescription Preview
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(_prescriptionImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Change Image Button
                        OutlinedButton.icon(
                          onPressed: _uploadPrescription,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Change Prescription'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // AI Analysis Result
                  if (_isAnalyzing)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Analyzing prescription with AI...'),
                        ],
                      ),
                    ),

                  if (_aiResult != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _aiResult!.contains('✅')
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _aiResult!.contains('✅')
                              ? Colors.green.withValues(alpha: 0.3)
                              : Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _aiResult!.contains('✅')
                                    ? Icons.check_circle
                                    : Icons.info,
                                color: _aiResult!.contains('✅')
                                    ? Colors.green
                                    : Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'AI Analysis Result',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(_aiResult!, style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 80), // Space for button
          ],
        ),
      ),

      // Book Test Button (Fixed at bottom)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Booking Confirmation'),
                  content: Text(
                    'Book diagnostic tests at ${widget.center['name']}?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Test booking confirmed! You will receive a confirmation SMS.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Book Test',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
