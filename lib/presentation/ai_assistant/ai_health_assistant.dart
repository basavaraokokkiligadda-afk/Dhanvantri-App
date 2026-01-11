import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../core/app_export.dart';
import '../widgets/conversation_bubble_widget.dart';
import '../widgets/doctor_suggestion_card_widget.dart';
import '../widgets/language_selector_widget.dart';

class AiHealthAssistant extends StatefulWidget {
  const AiHealthAssistant({super.key});

  @override
  State<AiHealthAssistant> createState() => _AiHealthAssistantState();
}

class _AiHealthAssistantState extends State<AiHealthAssistant>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final RecorderController _waveformController = RecorderController();

  bool _isRecording = false;
  bool _isProcessing = false;
  String _selectedLanguage = 'English';

  final List<Map<String, dynamic>> _conversationHistory = [];

  final List<Map<String, dynamic>> _mockDoctorSuggestions = [
    {
      "id": 1,
      "specialization": "General Physician",
      "icon": "medical_services",
      "experience": "10+ years",
      "availability": "Available",
      "availabilityColor": Colors.green,
      "description": "For general health concerns and initial diagnosis",
    },
    {
      "id": 2,
      "specialization": "Cardiologist",
      "icon": "favorite",
      "experience": "15+ years",
      "availability": "Available",
      "availabilityColor": Colors.green,
      "description": "For heart-related symptoms and cardiovascular issues",
    },
    {
      "id": 3,
      "specialization": "Neurologist",
      "icon": "psychology",
      "experience": "12+ years",
      "availability": "Busy",
      "availabilityColor": Colors.orange,
      "description": "For neurological symptoms and brain-related concerns",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );
    _scaleController.forward();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    if (!kIsWeb) {
      await _waveformController.checkPermission();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  Future<void> _requestMicrophonePermission() async {
    if (kIsWeb) return;
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required for voice input'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      await _requestMicrophonePermission();

      if (await _audioRecorder.hasPermission()) {
        setState(() => _isRecording = true);

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording.wav',
          );
        } else {
          await _waveformController.record();
        }
      }
    } catch (e) {
      setState(() => _isRecording = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start recording. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      if (kIsWeb) {
        await _audioRecorder.stop();
      } else {
        await _waveformController.stop();
      }

      await Future.delayed(const Duration(seconds: 2));

      _addMessage(
        'I\'m experiencing headaches and dizziness for the past few days.',
        true,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      _addMessage(
        'Based on your symptoms of headaches and dizziness, I recommend consulting a Neurologist or General Physician. These symptoms could indicate various conditions that require professional evaluation. I\'ve suggested some specialists below.',
        false,
      );

      setState(() => _isProcessing = false);
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process recording. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _addMessage(String message, bool isUser) {
    setState(() {
      _conversationHistory.add({
        'message': message,
        'isUser': isUser,
        'timestamp': DateTime.now(),
      });
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleTextSubmit() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _addMessage(text, true);
    _textController.clear();

    setState(() => _isProcessing = true);

    Future.delayed(const Duration(seconds: 2), () {
      _addMessage(
        'Thank you for sharing your symptoms. Based on what you\'ve described, I recommend consulting with a specialist. Please review the doctor suggestions below for appropriate medical guidance.',
        false,
      );
      setState(() => _isProcessing = false);
    });
  }

  void _handleLanguageChange(String language) {
    setState(() => _selectedLanguage = language);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to $_selectedLanguage'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleDoctorBooking(Map<String, dynamic> doctor) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/appointment-booking', arguments: doctor);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: 95.w, maxHeight: 85.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(theme),
              Expanded(child: _buildConversationArea(theme)),
              _buildInputArea(theme),
              _buildDoctorSuggestions(theme),
              _buildDisclaimer(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'psychology',
              color: theme.colorScheme.primary,
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
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Powered by Medical AI',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          LanguageSelectorWidget(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: _handleLanguageChange,
          ),
          SizedBox(width: 2.w),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'close',
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildConversationArea(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: _conversationHistory.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              controller: _scrollController,
              itemCount: _conversationHistory.length,
              itemBuilder: (context, index) {
                final message = _conversationHistory[index];
                return ConversationBubbleWidget(
                  message: message['message'] as String,
                  isUser: message['isUser'] as bool,
                  timestamp: message['timestamp'] as DateTime,
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'chat',
              color: theme.colorScheme.primary,
              size: 48,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Start a conversation',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'Describe your symptoms using voice or text, and I\'ll help you find the right medical guidance',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          if (_isRecording) _buildWaveformDisplay(theme),
          if (_isRecording) SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _textController,
                    enabled: !_isRecording && !_isProcessing,
                    style: theme.textTheme.bodyMedium,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Describe your symptoms...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ),
                    ),
                    onSubmitted: (_) => _handleTextSubmit(),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              _buildMicrophoneButton(theme),
              SizedBox(width: 2.w),
              _buildSendButton(theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformDisplay(ThemeData theme) {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: kIsWeb
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'graphic_eq',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Recording...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : AudioWaveforms(
              size: Size(80.w, 6.h),
              recorderController: _waveformController,
              waveStyle: WaveStyle(
                waveColor: theme.colorScheme.primary,
                extendWaveform: true,
                showMiddleLine: false,
              ),
            ),
    );
  }

  Widget _buildMicrophoneButton(ThemeData theme) {
    return GestureDetector(
      onTap: _isProcessing
          ? null
          : (_isRecording ? _stopRecording : _startRecording),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: _isRecording
              ? theme.colorScheme.error
              : theme.colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: _isRecording
              ? [
                  BoxShadow(
                    color: theme.colorScheme.error.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: CustomIconWidget(
          iconName: _isRecording ? 'stop' : 'mic',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSendButton(ThemeData theme) {
    return GestureDetector(
      onTap: _isProcessing || _isRecording ? null : _handleTextSubmit,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: _textController.text.isEmpty
              ? theme.colorScheme.outline.withValues(alpha: 0.3)
              : theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: const CustomIconWidget(
          iconName: 'send',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDoctorSuggestions(ThemeData theme) {
    if (_conversationHistory.length < 2) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_hospital',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Recommended Specialists',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 18.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _mockDoctorSuggestions.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final doctor = _mockDoctorSuggestions[index];
                return DoctorSuggestionCardWidget(
                  doctor: doctor,
                  onBookAppointment: () => _handleDoctorBooking(doctor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'info_outline',
            color: theme.colorScheme.error,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'This is an AI assistant. Always consult a qualified doctor for medical advice.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
