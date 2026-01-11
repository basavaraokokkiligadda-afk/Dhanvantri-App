import 'package:intl/intl.dart';

import '../../../core/app_export.dart';

class PrescriptionPreviewWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback onLongPress;

  const PrescriptionPreviewWidget({
    super.key,
    required this.message,
    required this.onLongPress,
  });

  void _showFullImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullImageView(
          imageUrl: message["imageUrl"],
          semanticLabel: message["semanticLabel"] ?? "Prescription image",
        ),
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
                      onTap: () => _showFullImage(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isSent ? 16 : 4),
                          bottomRight: Radius.circular(isSent ? 4 : 16),
                        ),
                        child: Stack(
                          children: [
                            CustomImageWidget(
                              imageUrl: message["imageUrl"],
                              width: 70.w,
                              height: 30.h,
                              fit: BoxFit.cover,
                              semanticLabel:
                                  message["semanticLabel"] ??
                                  "Prescription image",
                            ),
                            Positioned(
                              top: 2.h,
                              right: 2.w,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const CustomIconWidget(
                                  iconName: 'zoom_in',
                                  color: Colors.white,
                                  size: 20,
                                ),
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
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'description',
                                color: isSent
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.primary,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Prescription',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSent
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
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

class _FullImageView extends StatelessWidget {
  final String imageUrl;
  final String semanticLabel;

  const _FullImageView({
    required this.imageUrl,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const CustomIconWidget(
              iconName: 'download',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Prescription downloaded'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
          ),
          IconButton(
            icon: const CustomIconWidget(
              iconName: 'text_fields',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('OCR text extraction started'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: CustomImageWidget(
            imageUrl: imageUrl,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
            semanticLabel: semanticLabel,
          ),
        ),
      ),
    );
  }
}
