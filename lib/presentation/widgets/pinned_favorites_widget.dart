import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

/// Widget for displaying pinned favorite members
/// Horizontally scrollable with up to 5 member profiles
class PinnedFavoritesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> favorites;
  final Function(int) onFavoriteTap;

  const PinnedFavoritesWidget({
    super.key,
    required this.favorites,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (favorites.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'push_pin',
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Pinned Favorites',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: favorites.length > 5 ? 5 : favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return _buildFavoriteItem(context, theme, favorite);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> favorite,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onFavoriteTap(favorite["id"] as int);
      },
      child: Container(
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.scaffoldBackgroundColor,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: favorite["avatar"] as String,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        semanticLabel: favorite["semanticLabel"] as String,
                      ),
                    ),
                  ),
                ),
                if (favorite["isDoctor"] as bool)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'verified',
                        color: theme.colorScheme.onPrimary,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              favorite["name"] as String,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
