
import '../../../core/app_export.dart';

class CommentBottomSheetWidget extends StatefulWidget {
  final int videoId;
  final int commentCount;

  const CommentBottomSheetWidget({
    super.key,
    required this.videoId,
    required this.commentCount,
  });

  @override
  State<CommentBottomSheetWidget> createState() =>
      _CommentBottomSheetWidgetState();
}

class _CommentBottomSheetWidgetState extends State<CommentBottomSheetWidget> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {
      "id": 1,
      "userName": "Rahul Verma",
      "userImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1f49e613a-1763296527029.png",
      "semanticLabel":
          "Profile photo of a young Indian man with short black hair wearing a casual t-shirt",
      "comment":
          "Very informative! Thanks for sharing this valuable information.",
      "timestamp": "2 hours ago",
      "likes": 45,
    },
    {
      "id": 2,
      "userName": "Anjali Gupta",
      "userImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1ac0f6910-1763299885644.png",
      "semanticLabel":
          "Profile photo of an Indian woman with long hair wearing traditional attire",
      "comment": "This is exactly what I needed to know. Great explanation!",
      "timestamp": "5 hours ago",
      "likes": 32,
    },
    {
      "id": 3,
      "userName": "Suresh Patel",
      "userImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_14f1cfca4-1763294024030.png",
      "semanticLabel":
          "Profile photo of a middle-aged Indian man with glasses and a friendly smile",
      "comment": "Could you please make more videos on this topic?",
      "timestamp": "1 day ago",
      "likes": 28,
    },
    {
      "id": 4,
      "userName": "Deepika Singh",
      "userImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_12e0872fa-1763301528871.png",
      "semanticLabel":
          "Profile photo of a young Indian woman with shoulder-length hair and a bright smile",
      "comment": "Shared this with my family. Everyone found it helpful!",
      "timestamp": "1 day ago",
      "likes": 56,
    },
    {
      "id": 5,
      "userName": "Karthik Reddy",
      "userImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_10cd2e22c-1763299330725.png",
      "semanticLabel":
          "Profile photo of an Indian man with short hair wearing professional attire",
      "comment": "Amazing content! Keep up the good work doctor.",
      "timestamp": "2 days ago",
      "likes": 41,
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outline, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.commentCount} Comments',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return _buildCommentItem(context, comment);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.colorScheme.outline, width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'send',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, Map<String, dynamic> comment) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: comment["userImage"] as String,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              semanticLabel: comment["semanticLabel"] as String,
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
                  Expanded(
                    child: Text(
                      comment["userName"] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    comment["timestamp"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment["comment"] as String,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'favorite_border',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${comment["likes"]}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Reply',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
