import 'package:flutter/services.dart';
import 'package:record/record.dart';

import '../../../core/app_export.dart';

class AIAssistantModalWidget extends StatefulWidget {
  const AIAssistantModalWidget({super.key});

  @override
  State<AIAssistantModalWidget> createState() => _AIAssistantModalWidgetState();
}

class _AIAssistantModalWidgetState extends State<AIAssistantModalWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  late AnimationController _glowController;
  late AnimationController _waveController;
  bool _isRecording = false;
  bool _isProcessing = false;
  String _selectedLanguage = 'English';

  final List<String> _languages = [
    'English',
    'తెలుగు (Telugu)',
    'हिंदी (Hindi)',
    'தமிழ் (Tamil)',
  ];

  final List<Map<String, dynamic>> _suggestions = [
    {
      "icon": "favorite",
      "text": "Check heart rate",
      "color": const Color(0xFFDC2626),
    },
    {
      "icon": "thermostat",
      "text": "Fever symptoms",
      "color": const Color(0xFFF59E0B),
    },
    {"icon": "healing", "text": "Find specialist", "color": const Color(0xFF059669)},
    {"icon": "medication", "text": "Medicine info", "color": const Color(0xFF4A90B8)},
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _audioRecorder.dispose();
    _glowController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    HapticFeedback.mediumImpact();

    if (_isRecording) {
      await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });
      _waveController.stop();

      // Simulate processing
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isProcessing = false);
        _showResponse();
      }
    } else {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(const RecordConfig(), path: 'recording.m4a');
        setState(() => _isRecording = true);
        _waveController.repeat();
      }
    }
  }

  void _showResponse() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Health Assistant'),
        content: const Text(
          'Based on your symptoms, I recommend consulting a general physician. Would you like to book an appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const CustomIconWidget(
                    iconName: 'psychology',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Health Assistant',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Ask me anything about your health',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Language Selector
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'language',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Language:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _languages.map((lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedLanguage = value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Quick Suggestions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Suggestions',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _suggestions.map((suggestion) {
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _textController.text = suggestion["text"] as String;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: (suggestion["color"] as Color).withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (suggestion["color"] as Color).withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: suggestion["icon"] as String,
                              color: suggestion["color"] as Color,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              suggestion["text"] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: suggestion["color"] as Color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Voice Recording Visualization
          if (_isRecording || _isProcessing)
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final delay = index * 0.2;
                          final value = (_waveController.value + delay) % 1.0;
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            width: 1.w,
                            height: 8.h * (0.3 + (value * 0.7)),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _isProcessing ? 'Processing...' : 'Listening...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Input Section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Type your health query...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return Container(
                          width: 14.w,
                          height: 14.w,
                          decoration: BoxDecoration(
                            color: _isRecording
                                ? const Color(0xFFDC2626)
                                : theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_isRecording
                                        ? const Color(0xFFDC2626)
                                        : theme.colorScheme.primary)
                                    .withValues(
                                  alpha: 0.3 + (_glowController.value * 0.3),
                                ),
                                blurRadius: 8 + (_glowController.value * 8),
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: _isRecording ? 'stop' : 'mic',
                            color: Colors.white,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () {
                      if (_textController.text.isNotEmpty) {
                        HapticFeedback.lightImpact();
                        setState(() => _isProcessing = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() => _isProcessing = false);
                            _showResponse();
                          }
                        });
                      }
                    },
                    child: Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const CustomIconWidget(
                        iconName: 'send',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
