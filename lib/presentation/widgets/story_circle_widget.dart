
import '../../../core/app_export.dart';

/// Story Circle Widget - Individual story preview circle
/// Displays user profile photo with colored ring for unviewed content
class StoryCircleWidget extends StatelessWidget {
  final String userName;
  final String userImage;
  final String semanticLabel;
  final bool isVerified;
  final bool hasUnviewedStory;
  final VoidCallback onTap;

  const StoryCircleWidget({
    super.key,
    required this.userName,
    required this.userImage,
    required this.semanticLabel,
    required this.isVerified,
    required this.hasUnviewedStory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 20.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Story circle with gradient ring
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasUnviewedStory
                    ? LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                border: !hasUnviewedStory
                    ? Border.all(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.3,
                        ),
                        width: 2,
                      )
                    : null,
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface,
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: userImage,
                    width: 18.w,
                    height: 18.w,
                    fit: BoxFit.cover,
                    semanticLabel: semanticLabel,
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            // User name with verification badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    userName.split(' ')[0], // First name only
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: hasUnviewedStory
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (isVerified) ...[
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'verified',
                    color: theme.colorScheme.primary,
                    size: 12,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
