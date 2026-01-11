import '../../../core/app_export.dart';

class VideoActionPanelWidget extends StatelessWidget {
  final Map<String, dynamic> videoData;
  final bool isLiked;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;

  const VideoActionPanelWidget({
    super.key,
    required this.videoData,
    required this.isLiked,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
  });

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          context: context,
          icon: isLiked ? 'favorite' : 'favorite_border',
          label: _formatCount(videoData["likes"] as int),
          onTap: onLikeTap,
          color: isLiked ? Colors.red : Colors.white,
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          context: context,
          icon: 'chat_bubble_outline',
          label: _formatCount(videoData["comments"] as int),
          onTap: onCommentTap,
          color: Colors.white,
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          context: context,
          icon: 'share',
          label: _formatCount(videoData["shares"] as int),
          onTap: onShareTap,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.3),
            ),
            child: CustomIconWidget(iconName: icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
