
import '../../../core/app_export.dart';

class ShareBottomSheetWidget extends StatelessWidget {
  final Map<String, dynamic> videoData;

  const ShareBottomSheetWidget({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final shareOptions = [
      {"icon": "chat", "label": "ChitChat", "color": theme.colorScheme.primary},
      {
        "icon": "link",
        "label": "Copy Link",
        "color": theme.colorScheme.secondary,
      },
      {"icon": "share", "label": "More", "color": theme.colorScheme.tertiary},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 24),
            Text(
              'Share Video',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: shareOptions.map((option) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    if (option["label"] == "ChitChat") {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed('/chit-chat-messaging');
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: (option["color"] as Color).withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: option["icon"] as String,
                            color: option["color"] as Color,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option["label"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
