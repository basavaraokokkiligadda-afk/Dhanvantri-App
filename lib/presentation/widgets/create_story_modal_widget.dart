import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../core/app_export.dart';

/// Create Story Modal Widget - Story creation interface
/// Offers camera capture, gallery selection, voice recording, and text composition
class CreateStoryModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onStoryCreated;

  const CreateStoryModalWidget({super.key, required this.onStoryCreated});

  @override
  State<CreateStoryModalWidget> createState() => _CreateStoryModalWidgetState();
}

class _CreateStoryModalWidgetState extends State<CreateStoryModalWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  Future<void> _capturePhoto() async {
    try {
      if (!kIsWeb) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          _showError('Camera permission denied');
          return;
        }
      }

      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        final storyData = {
          "type": "image",
          "content": photo.path,
          "semanticLabel": "User captured photo for story",
          "duration": 15,
          "timestamp": DateTime.now(),
        };
        widget.onStoryCreated(storyData);
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      _showError('Failed to capture photo');
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      if (!kIsWeb) {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          _showError('Gallery permission denied');
          return;
        }
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        final storyData = {
          "type": "image",
          "content": image.path,
          "semanticLabel": "User selected image from gallery for story",
          "duration": 15,
          "timestamp": DateTime.now(),
        };
        widget.onStoryCreated(storyData);
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      _showError('Failed to select image');
    }
  }

  Future<void> _toggleRecording() async {
    try {
      if (_isRecording) {
        final path = await _audioRecorder.stop();
        if (path != null) {
          final storyData = {
            "type": "voice",
            "content": path,
            "duration": 15,
            "timestamp": DateTime.now(),
            "transcript": "Voice recording",
            "waveformData": [0.2, 0.5, 0.8, 0.6, 0.9, 0.4, 0.7, 0.3, 0.6, 0.8],
          };
          widget.onStoryCreated(storyData);
          if (mounted) Navigator.pop(context);
        }
        setState(() {
          _isRecording = false;
        });
      } else {
        if (await _audioRecorder.hasPermission()) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording_${DateTime.now().millisecondsSinceEpoch}.wav',
          );
          setState(() {
            _isRecording = true;
          });
        } else {
          _showError('Microphone permission denied');
        }
      }
    } catch (e) {
      _showError('Failed to record audio');
    }
  }

  void _createTextStory() {
    showDialog(
      context: context,
      builder: (context) => _TextStoryDialog(
        onStoryCreated: (storyData) {
          widget.onStoryCreated(storyData);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Create Story',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),

          // Camera option
          _buildOption(
            theme: theme,
            icon: 'camera_alt',
            title: 'Camera',
            subtitle: 'Take a photo',
            onTap: _capturePhoto,
          ),
          SizedBox(height: 2.h),

          // Gallery option
          _buildOption(
            theme: theme,
            icon: 'photo_library',
            title: 'Gallery',
            subtitle: 'Choose from gallery',
            onTap: _selectFromGallery,
          ),
          SizedBox(height: 2.h),

          // Voice recording option
          _buildOption(
            theme: theme,
            icon: _isRecording ? 'stop' : 'mic',
            title: _isRecording ? 'Stop Recording' : 'Voice',
            subtitle: _isRecording ? 'Tap to stop' : 'Record voice message',
            onTap: _toggleRecording,
            isRecording: _isRecording,
          ),
          SizedBox(height: 2.h),

          // Text option
          _buildOption(
            theme: theme,
            icon: 'text_fields',
            title: 'Text',
            subtitle: 'Create text story',
            onTap: _createTextStory,
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _buildOption({
    required ThemeData theme,
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isRecording = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isRecording
              ? theme.colorScheme.error.withValues(alpha: 0.1)
              : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRecording
                ? theme.colorScheme.error
                : theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isRecording
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _TextStoryDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onStoryCreated;

  const _TextStoryDialog({required this.onStoryCreated});

  @override
  State<_TextStoryDialog> createState() => _TextStoryDialogState();
}

class _TextStoryDialogState extends State<_TextStoryDialog> {
  final TextEditingController _textController = TextEditingController();
  Color _selectedBackground = const Color(0xFF2E7D5A);

  final List<Color> _backgroundColors = [
    const Color(0xFF2E7D5A),
    const Color(0xFF4A90B8),
    const Color(0xFF059669),
    const Color(0xFFF59E0B),
    const Color(0xFFDC2626),
    const Color(0xFF8B5CF6),
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _createStory() {
    if (_textController.text.trim().isEmpty) {
      return;
    }

    final storyData = {
      "type": "text",
      "content": _textController.text.trim(),
      "backgroundColor": _selectedBackground,
      "duration": 15,
      "timestamp": DateTime.now(),
    };

    widget.onStoryCreated(storyData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create Text Story',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            TextField(
              controller: _textController,
              maxLines: 5,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'Share your health journey...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Background Color',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              children: _backgroundColors.map((color) {
                final isSelected = color == _selectedBackground;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBackground = color;
                    });
                  },
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createStory,
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
