import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';

/// Conversation card widget with swipe actions
/// Displays healthcare professional info, last message, and status
class ConversationCardWidget extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;
  final VoidCallback onArchive;
  final VoidCallback onMute;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const ConversationCardWidget({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onArchive,
    required this.onMute,
    required this.onDelete,
    required this.onLongPress,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOnline = conversation["isOnline"] as bool? ?? false;
    final unreadCount = conversation["unreadCount"] as int? ?? 0;
    final isPinned = conversation["isPinned"] as bool? ?? false;
    final isHealthcareProfessional =
        conversation["isHealthcareProfessional"] as bool? ?? false;

    return Slidable(
      key: ValueKey(conversation["id"]),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onArchive(),
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: Icons.archive_rounded,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: (context) => onMute(),
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: Colors.white,
            icon: Icons.notifications_off_rounded,
            label: 'Mute',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: isPinned
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: theme.dividerColor, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Avatar with online status
              Stack(
                children: [
                  Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: conversation["avatar"] as String? ?? "",
                        width: 14.w,
                        height: 14.w,
                        fit: BoxFit.cover,
                        semanticLabel:
                            conversation["semanticLabel"] as String? ??
                                "User profile photo",
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 3.5.w,
                        height: 3.5.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 3.w),

              // Conversation details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (isPinned) ...[
                                CustomIconWidget(
                                  iconName: 'push_pin',
                                  color: theme.colorScheme.primary,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                              ],
                              Flexible(
                                child: Text(
                                  conversation["name"] as String? ?? "User",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: unreadCount > 0
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isHealthcareProfessional) ...[
                                SizedBox(width: 1.w),
                                CustomIconWidget(
                                  iconName: 'verified',
                                  color: theme.colorScheme.primary,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _formatTimestamp(
                            conversation["timestamp"] as DateTime,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: unreadCount > 0
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation["lastMessage"] as String? ??
                                "No message",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: unreadCount > 0
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: unreadCount > 0
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unreadCount > 0) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 5.w,
                              minHeight: 2.5.h,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
    );
  }
}
