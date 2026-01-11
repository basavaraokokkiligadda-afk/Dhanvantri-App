import 'package:intl/intl.dart';

import '../../../core/app_export.dart';

class VoiceMessageWidget extends StatefulWidget {
  final Map<String, dynamic> message;
  final VoidCallback onLongPress;

  const VoiceMessageWidget({
    super.key,
    required this.message,
    required this.onLongPress,
  });

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _waveformController;

  @override
  void initState() {
    super.initState();
    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _waveformController.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _waveformController.repeat();
    } else {
      _waveformController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSent = widget.message["isSent"] == true;
    final timestamp = widget.message["timestamp"] as DateTime;
    final duration = widget.message["duration"] ?? 0;
    final isRead = widget.message["isRead"] == true;
    final isVerified = widget.message["isVerified"] == true;

    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Row(
          mainAxisAlignment:
              isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isSent) ...[
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.message["senderName"]?.substring(0, 1) ?? "D",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 70.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isSent ? 16 : 4),
                    bottomRight: Radius.circular(isSent ? 4 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isSent && isVerified) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.message["senderName"] ?? "",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: 'verified',
                            color: theme.colorScheme.primary,
                            size: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                    ],
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _togglePlayback,
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: isSent
                                  ? theme.colorScheme.onPrimary.withValues(
                                      alpha: 0.2,
                                    )
                                  : theme.colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: _isPlaying ? 'pause' : 'play_arrow',
                                color: isSent
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWaveform(theme, isSent),
                              SizedBox(height: 0.5.h),
                              Text(
                                '${duration}s',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSent
                                      ? theme.colorScheme.onPrimary.withValues(
                                          alpha: 0.7,
                                        )
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSent
                                ? theme.colorScheme.onPrimary.withValues(
                                    alpha: 0.7,
                                  )
                                : theme.colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                          ),
                        ),
                        if (isSent) ...[
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: isRead ? 'done_all' : 'done',
                            color: isRead
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.onPrimary.withValues(
                                    alpha: 0.7,
                                  ),
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveform(ThemeData theme, bool isSent) {
    return AnimatedBuilder(
      animation: _waveformController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(20, (index) {
            final height = _isPlaying
                ? (10 +
                    (15 *
                        (0.5 +
                            0.5 *
                                (index / 20 - _waveformController.value)
                                    .abs())))
                : 10.0;
            return Container(
              width: 2,
              height: height,
              decoration: BoxDecoration(
                color: isSent
                    ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                    : theme.colorScheme.primary.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
