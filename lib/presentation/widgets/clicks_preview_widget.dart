import 'package:intl/intl.dart';

import '../../../core/app_export.dart';

class ClicksPreviewWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback onLongPress;

  const ClicksPreviewWidget({
    super.key,
    required this.message,
    required this.onLongPress,
  });

  void _playVideo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening video player...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSent = message["isSent"] == true;
    final timestamp = message["timestamp"] as DateTime;
    final isRead = message["isRead"] == true;
    final isVerified = message["isVerified"] == true;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Row(
          mainAxisAlignment: isSent
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
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
                    message["senderName"]?.substring(0, 1) ?? "D",
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 1.5.h, 4.w, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message["senderName"] ?? "",
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
                      ),
                      SizedBox(height: 1.h),
                    ],
                    GestureDetector(
                      onTap: () => _playVideo(context),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            CustomImageWidget(
                              imageUrl: message["thumbnailUrl"],
                              width: 70.w,
                              height: 25.h,
                              fit: BoxFit.cover,
                              semanticLabel:
                                  message["semanticLabel"] ?? "Video thumbnail",
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  width: 15.w,
                                  height: 15.w,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'play_arrow',
                                      color: theme.colorScheme.onPrimary,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2.h,
                              left: 3.w,
                              child: Row(
                                children: [
                                  const CustomIconWidget(
                                    iconName: 'play_circle_outline',
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    message["views"] ?? "0",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message["title"] ?? "",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isSent
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
