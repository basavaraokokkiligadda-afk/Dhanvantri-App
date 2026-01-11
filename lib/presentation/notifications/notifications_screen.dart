import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';

/// Notifications Screen showing all app notifications
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notification data
  final List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': 'Appointment Confirmed',
      'message':
          'Your appointment with Dr. Sharma is confirmed for Jan 12, 10:00 AM',
      'time': '2 hours ago',
      'icon': Icons.event_available,
      'color': const Color(0xFF10B981),
      'isRead': false,
    },
    {
      'id': 2,
      'title': 'Free Medical Camp',
      'message':
          'New free medical camp near you at Community Hall, Jubilee Hills',
      'time': '5 hours ago',
      'icon': Icons.volunteer_activism,
      'color': const Color(0xFFF59E0B),
      'isRead': false,
    },
    {
      'id': 3,
      'title': 'Medicine Delivered',
      'message': 'Your medicine order #1234 has been delivered successfully',
      'time': '1 day ago',
      'icon': Icons.local_shipping,
      'color': const Color(0xFF3B82F6),
      'isRead': true,
    },
    {
      'id': 4,
      'title': 'Medicine Reminder',
      'message': 'Time to take your medicine: Aspirin 100mg',
      'time': '1 day ago',
      'icon': Icons.medication,
      'color': const Color(0xFFEF4444),
      'isRead': true,
    },
    {
      'id': 5,
      'title': 'Lab Report Ready',
      'message': 'Your blood test report is ready. Tap to view details',
      'time': '2 days ago',
      'icon': Icons.description,
      'color': const Color(0xFF8B5CF6),
      'isRead': true,
    },
  ];

  void _markAsRead(int id) {
    setState(() {
      final notification = notifications.firstWhere((n) => n['id'] == id);
      notification['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount =
        notifications.where((n) => !(n['isRead'] as bool)).length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications'),
            if (unreadCount > 0)
              Text(
                '$unreadCount new',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(theme)
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 76,
                color: theme.dividerColor,
              ),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationItem(theme, notification);
              },
            ),
    );
  }

  Widget _buildNotificationItem(
      ThemeData theme, Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _markAsRead(notification['id'] as int);
      },
      child: Container(
        color: isRead ? null : theme.primaryColor.withValues(alpha: 0.05),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (notification['color'] as Color).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification['icon'] as IconData,
                color: notification['color'] as Color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight:
                                isRead ? FontWeight.w500 : FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
