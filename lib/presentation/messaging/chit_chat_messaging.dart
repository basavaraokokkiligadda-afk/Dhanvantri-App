import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../widgets/conversation_card_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'chat_detail_screen.dart';

/// ChitChat Messaging Screen - Normal user-to-user conversations
/// Implements bottom tab navigation with ChitChat tab active
/// Features: End-to-end encryption, search, one-to-one chats with normal users
class ChitChatMessaging extends StatefulWidget {
  const ChitChatMessaging({super.key});

  @override
  State<ChitChatMessaging> createState() => _ChitChatMessagingState();
}

class _ChitChatMessagingState extends State<ChitChatMessaging>
    with SingleTickerProviderStateMixin {
  // Search state
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Animation controller for staggered animations
  late AnimationController _animationController;

  // Mock normal user conversations data (NOT doctors/hospitals)
  final List<Map<String, dynamic>> _conversations = [
    {
      "id": 1,
      "name": "Ravi",
      "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d",
      "semanticLabel": "Profile photo of Ravi, a young man with short hair",
      "lastMessage": "Hey! Are you free this weekend?",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "unreadCount": 2,
      "isOnline": true,
      "isPinned": false,
    },
    {
      "id": 2,
      "name": "Anjali",
      "avatar": "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
      "semanticLabel": "Profile photo of Anjali, a young woman with long hair",
      "lastMessage": "That sounds like a great plan!",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "unreadCount": 0,
      "isOnline": true,
      "isPinned": true,
    },
    {
      "id": 3,
      "name": "Suresh",
      "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
      "semanticLabel": "Profile photo of Suresh, a man with glasses",
      "lastMessage": "Let's catch up soon",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "unreadCount": 1,
      "isOnline": false,
      "isPinned": false,
    },
    {
      "id": 4,
      "name": "Kiran",
      "avatar": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80",
      "semanticLabel":
          "Profile photo of Kiran, a woman with shoulder-length hair",
      "lastMessage": "Thanks for the help!",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "unreadCount": 0,
      "isOnline": false,
      "isPinned": false,
    },
    {
      "id": 5,
      "name": "Priya",
      "avatar": "https://images.unsplash.com/photo-1544005313-94ddf0286df2",
      "semanticLabel": "Profile photo of Priya, a young woman smiling",
      "lastMessage": "See you tomorrow!",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "unreadCount": 0,
      "isOnline": true,
      "isPinned": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter conversations based on search query
  List<Map<String, dynamic>> get _filteredConversations {
    if (_searchQuery.isEmpty) {
      return _conversations;
    }
    return _conversations.where((conversation) {
      final name = (conversation["name"] as String? ?? "").toLowerCase();
      final lastMessage =
          (conversation["lastMessage"] as String? ?? "").toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || lastMessage.contains(query);
    }).toList();
  }

  // Sort conversations: pinned first, then by timestamp
  List<Map<String, dynamic>> get _sortedConversations {
    final filtered = _filteredConversations;
    filtered.sort((a, b) {
      final aPinned = a["isPinned"] as bool? ?? false;
      final bPinned = b["isPinned"] as bool? ?? false;
      if (aPinned && !bPinned) return -1;
      if (!aPinned && bPinned) return 1;
      return (b["timestamp"] as DateTime).compareTo(a["timestamp"] as DateTime);
    });
    return filtered;
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _navigateToChat(Map<String, dynamic> conversation) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(user: conversation),
      ),
    );
  }

  void _onArchive(Map<String, dynamic> conversation) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${conversation["name"]} archived'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onMute(Map<String, dynamic> conversation) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${conversation["name"]} muted'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onDelete(Map<String, dynamic> conversation) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text(
          'Are you sure you want to delete this conversation with ${conversation["name"]}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _conversations.removeWhere(
                  (c) => c["id"] == conversation["id"],
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Conversation deleted'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onPin(Map<String, dynamic> conversation) {
    HapticFeedback.mediumImpact();
    setState(() {
      final currentPinned = conversation["isPinned"] as bool? ?? false;
      conversation["isPinned"] = !currentPinned;
    });
    final isPinned = conversation["isPinned"] as bool? ?? false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${conversation["name"]} ${isPinned ? "pinned" : "unpinned"}',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onMarkUnread(Map<String, dynamic> conversation) {
    HapticFeedback.mediumImpact();
    setState(() {
      conversation["unreadCount"] = 1;
    });
  }

  void _onBlock(Map<String, dynamic> conversation) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text(
          'Are you sure you want to block ${conversation["name"]}? You will no longer receive messages from this user.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${conversation["name"]} blocked'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> conversation) {
    HapticFeedback.mediumImpact();
    final isPinned = conversation["isPinned"] as bool? ?? false;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: isPinned ? 'push_pin' : 'push_pin_outlined',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(isPinned ? 'Unpin' : 'Pin'),
              onTap: () {
                Navigator.pop(context);
                _onPin(conversation);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'mark_chat_unread',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Mark as Unread'),
              onTap: () {
                Navigator.pop(context);
                _onMarkUnread(conversation);
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'block',
                color: Colors.red,
                size: 24,
              ),
              title:
                  const Text('Block User', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _onBlock(conversation);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startNewChat() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search for users to start a new chat'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Simulate refresh
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedConversations = _sortedConversations;

    return Column(
      children: [
        // Header with encryption indicator and search
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  children: [
                    if (!_isSearchActive) ...[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ChitChat',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'lock',
                                  color: theme.colorScheme.primary,
                                  size: 14,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'End-to-end encrypted',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleSearch,
                        icon: CustomIconWidget(
                          iconName: 'search',
                          color: theme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search conversations...',
                            border: InputBorder.none,
                            prefixIcon: CustomIconWidget(
                              iconName: 'search',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleSearch,
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: theme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),

        // Conversations list or empty state
        Expanded(
          child: sortedConversations.isEmpty
              ? EmptyStateWidget(onStartConsultation: _startNewChat)
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    itemCount: sortedConversations.length,
                    itemBuilder: (context, index) {
                      final conversation = sortedConversations[index];
                      final delay = index * 100;

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 400 + delay),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: ConversationCardWidget(
                          conversation: conversation,
                          onTap: () => _navigateToChat(conversation),
                          onArchive: () => _onArchive(conversation),
                          onMute: () => _onMute(conversation),
                          onDelete: () => _onDelete(conversation),
                          onLongPress: () => _showContextMenu(conversation),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
