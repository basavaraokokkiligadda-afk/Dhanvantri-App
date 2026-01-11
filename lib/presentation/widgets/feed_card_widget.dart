import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

/// Widget for individual feed post card
/// Includes user info, content, image, and interaction buttons
class FeedCardWidget extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final Function(String) onContextMenu;

  const FeedCardWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onContextMenu,
  });

  @override
  State<FeedCardWidget> createState() => _FeedCardWidgetState();
}

class _FeedCardWidgetState extends State<FeedCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _handleLike() {
    widget.onLike();
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse();
    });
  }

  void _showContextMenu() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildContextMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLiked = widget.post["isLiked"] as bool;

    return GestureDetector(
      onLongPress: _showContextMenu,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Navigate to user dashboard
                      Navigator.of(context).pushNamed('/user-dashboard');
                    },
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: widget.post["userAvatar"] as String,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        semanticLabel: widget.post["userAvatarLabel"] as String,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.post["userName"] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.post["credentials"] != null) ...[
                              const SizedBox(width: 4),
                              CustomIconWidget(
                                iconName: 'verified',
                                color: theme.colorScheme.primary,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                        if (widget.post["credentials"] != null)
                          Text(
                            widget.post["credentials"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          widget.post["timestamp"] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _showContextMenu,
                    icon: CustomIconWidget(
                      iconName: 'more_vert',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Post Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.post["content"] as String,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
            const SizedBox(height: 12),

            // Post Image
            if (widget.post["postImage"] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: widget.post["postImage"] as String,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  semanticLabel: widget.post["postImageLabel"] as String,
                ),
              ),

            // Interaction Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    '${widget.post["likes"]} likes',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${widget.post["comments"]} comments',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.post["shares"]} shares',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _handleLike,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ScaleTransition(
                              scale: _likeAnimation,
                              child: CustomIconWidget(
                                iconName:
                                    isLiked ? 'favorite' : 'favorite_border',
                                color: isLiked
                                    ? const Color(0xFFDC2626)
                                    : theme.colorScheme.onSurfaceVariant,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Like',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isLiked
                                    ? const Color(0xFFDC2626)
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: widget.onComment,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'chat_bubble_outline',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 22,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Comment',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: widget.onShare,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'share_outlined',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 22,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Share',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenu() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark_border',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Save Post'),
              onTap: () {
                Navigator.pop(context);
                widget.onContextMenu('save');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'flag_outlined',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Report Post'),
              onTap: () {
                Navigator.pop(context);
                widget.onContextMenu('report');
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'visibility_off_outlined',
                color: Color(0xFFDC2626),
                size: 24,
              ),
              title: const Text(
                'Hide User',
                style: TextStyle(color: Color(0xFFDC2626)),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onContextMenu('hide');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
