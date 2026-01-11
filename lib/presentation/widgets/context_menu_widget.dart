
import '../../../core/app_export.dart';

class ContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> videoData;
  final VoidCallback onFollowToggle;

  const ContextMenuWidget({
    super.key,
    required this.videoData,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFollowing = videoData["isFollowing"] as bool;

    final menuOptions = [
      {
        "icon": isFollowing ? "person_remove" : "person_add",
        "label": isFollowing
            ? "Unfollow"
            : "Follow ${videoData["creatorName"]}",
        "color": theme.colorScheme.primary,
        "action": () {
          onFollowToggle();
          Navigator.pop(context);
        },
      },
      {
        "icon": "bookmark_border",
        "label": "Save Video",
        "color": theme.colorScheme.secondary,
        "action": () {
          Navigator.pop(context);
        },
      },
      {
        "icon": "block",
        "label": "Not Interested",
        "color": theme.colorScheme.error,
        "action": () {
          Navigator.pop(context);
        },
      },
      {
        "icon": "flag",
        "label": "Report",
        "color": theme.colorScheme.error,
        "action": () {
          Navigator.pop(context);
        },
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ...menuOptions.map((option) {
              return InkWell(
                onTap: option["action"] as VoidCallback,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: option["icon"] as String,
                        color: option["color"] as Color,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option["label"] as String,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: option["color"] as Color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
