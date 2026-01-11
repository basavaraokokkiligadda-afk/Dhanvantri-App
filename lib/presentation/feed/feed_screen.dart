import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../widgets/feed_card_widget.dart';
import '../widgets/pinned_favorites_widget.dart';
import '../widgets/post_creation_modal_widget.dart';

/// Feed Screen - Main landing hub with healthcare content and social networking
/// Implements bottom tab navigation with Feed tab active
/// Features: Sticky header, segmented control, pinned favorites, vertical scrolling feed
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  // Mock data for pinned favorites
  final List<Map<String, dynamic>> pinnedFavorites = [
    {
      "id": 1,
      "name": "Dr. Sharma",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_104008a87-1763299273300.png",
      "semanticLabel":
          "Profile photo of Dr. Sharma, a male doctor with short black hair wearing white coat",
      "isDoctor": true,
    },
    {
      "id": 2,
      "name": "Priya",
      "avatar": "https://images.unsplash.com/photo-1548534544-7a4c15674617",
      "semanticLabel":
          "Profile photo of Priya, a young woman with long black hair smiling",
      "isDoctor": false,
    },
    {
      "id": 3,
      "name": "Dr. Patel",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_19d7714ef-1763294958604.png",
      "semanticLabel":
          "Profile photo of Dr. Patel, a male doctor with glasses and grey hair",
      "isDoctor": true,
    },
    {
      "id": 4,
      "name": "Anjali",
      "avatar": "https://images.unsplash.com/photo-1532562155872-8c00add1bb81",
      "semanticLabel":
          "Profile photo of Anjali, a woman with shoulder-length hair in traditional attire",
      "isDoctor": false,
    },
    {
      "id": 5,
      "name": "Dr. Kumar",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_104008a87-1763299273300.png",
      "semanticLabel":
          "Profile photo of Dr. Kumar, a male doctor with short hair and stethoscope",
      "isDoctor": true,
    },
  ];

  // Mock data for feed posts
  final List<Map<String, dynamic>> feedPosts = [
    {
      "id": 1,
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1fe03ce7b-1763294977207.png",
      "userAvatarLabel":
          "Profile photo of Dr. Rajesh Sharma, cardiologist with short black hair",
      "userName": "Dr. Rajesh Sharma",
      "credentials": "MBBS, MD - Cardiology",
      "timestamp": "2 hours ago",
      "content":
          "Regular exercise is crucial for heart health. Just 30 minutes of moderate activity daily can significantly reduce cardiovascular disease risk. Remember to consult your doctor before starting any new exercise routine.",
      "postImage":
          "https://images.unsplash.com/photo-1608383728784-9d33f8547430",
      "postImageLabel":
          "Person jogging on outdoor track during sunrise with mountains in background",
      "likes": 234,
      "comments": 45,
      "shares": 12,
      "isLiked": false,
    },
    {
      "id": 2,
      "userAvatar": "https://images.unsplash.com/photo-1557182549-099ccb56dbad",
      "userAvatarLabel":
          "Profile photo of Priya Mehta, health enthusiast with long black hair",
      "userName": "Priya Mehta",
      "credentials": null,
      "timestamp": "4 hours ago",
      "content":
          "Just completed my annual health checkup at Apollo Hospital. Early detection is key to preventing serious health issues. Don't skip your regular checkups!",
      "postImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1fabf5dd5-1767096923931.png",
      "postImageLabel":
          "Modern hospital reception area with clean white walls and medical staff at desk",
      "likes": 156,
      "comments": 28,
      "shares": 8,
      "isLiked": true,
    },
    {
      "id": 3,
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1ba95ba5e-1763300102901.png",
      "userAvatarLabel":
          "Profile photo of Dr. Anita Desai, nutritionist with glasses and professional attire",
      "userName": "Dr. Anita Desai",
      "credentials": "MSc Nutrition, Certified Dietitian",
      "timestamp": "6 hours ago",
      "content":
          "Hydration tip: Drink at least 8 glasses of water daily. Proper hydration improves digestion, skin health, and overall body function. Add lemon or cucumber for extra benefits!",
      "postImage":
          "https://images.unsplash.com/photo-1694681733468-15204fe9090b",
      "postImageLabel":
          "Glass of water with lemon slices and mint leaves on wooden table",
      "likes": 189,
      "comments": 34,
      "shares": 15,
      "isLiked": false,
    },
    {
      "id": 4,
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1832543f7-1763295530444.png",
      "userAvatarLabel":
          "Profile photo of Dr. Vikram Kumar, general physician with stethoscope",
      "userName": "Dr. Vikram Kumar",
      "credentials": "MBBS, MD - General Medicine",
      "timestamp": "8 hours ago",
      "content":
          "Mental health is as important as physical health. Practice mindfulness, get adequate sleep, and don't hesitate to seek professional help when needed. Your well-being matters.",
      "postImage":
          "https://images.unsplash.com/photo-1730104993558-90719dc6f1c5",
      "postImageLabel":
          "Person meditating in peaceful outdoor setting with morning sunlight",
      "likes": 312,
      "comments": 67,
      "shares": 23,
      "isLiked": true,
    },
    {
      "id": 5,
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1290f2055-1763299401840.png",
      "userAvatarLabel":
          "Profile photo of Sneha Reddy, fitness trainer with athletic wear",
      "userName": "Sneha Reddy",
      "credentials": "Certified Fitness Trainer",
      "timestamp": "10 hours ago",
      "content":
          "Strength training isn't just for bodybuilders! It helps maintain bone density, improves metabolism, and enhances overall quality of life. Start with bodyweight exercises and progress gradually.",
      "postImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1db9e309b-1767184647642.png",
      "postImageLabel":
          "Woman doing strength training exercises with dumbbells in modern gym",
      "likes": 198,
      "comments": 41,
      "shares": 19,
      "isLiked": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feed updated successfully'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showPostCreationModal() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PostCreationModalWidget(),
    );
  }

  void _handlePostAction(int postId, String action) {
    HapticFeedback.lightImpact();

    setState(() {
      final postIndex = feedPosts.indexWhere(
        (post) => (post["id"] as int) == postId,
      );
      if (postIndex != -1) {
        switch (action) {
          case 'like':
            feedPosts[postIndex]["isLiked"] =
                !(feedPosts[postIndex]["isLiked"] as bool);
            feedPosts[postIndex]["likes"] =
                (feedPosts[postIndex]["isLiked"] as bool)
                    ? (feedPosts[postIndex]["likes"] as int) + 1
                    : (feedPosts[postIndex]["likes"] as int) - 1;
            break;
          case 'comment':
            // Navigate to comments screen
            break;
          case 'share':
            feedPosts[postIndex]["shares"] =
                (feedPosts[postIndex]["shares"] as int) + 1;
            break;
        }
      }
    });

    if (action == 'share') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post shared successfully'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handlePostContextMenu(int postId, String action) {
    HapticFeedback.mediumImpact();

    String message = '';
    switch (action) {
      case 'save':
        message = 'Post saved to your collection';
        break;
      case 'report':
        message = 'Post reported. We will review it shortly';
        break;
      case 'hide':
        message = 'User hidden from your feed';
        setState(() {
          feedPosts.removeWhere((post) => (post["id"] as int) == postId);
        });
        break;
    }

    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            _buildStickyHeader(theme),

            // Segmented Control
            _buildSegmentedControl(theme),

            // Pinned Favorites
            PinnedFavoritesWidget(
              favorites: pinnedFavorites,
              onFavoriteTap: (id) {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Viewing ${pinnedFavorites.firstWhere((f) => (f["id"] as int) == id)["name"]} profile',
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),

            // Main Feed Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: theme.colorScheme.primary,
                child: _isRefreshing
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Updating your feed...',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildFeedList(theme),
                          _buildFeedList(theme),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPostCreationModal,
        backgroundColor: theme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildStickyHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User Profile DP
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // Navigate to user dashboard page
              Navigator.of(context).pushNamed('/user-dashboard');
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary, width: 2),
              ),
              child: const ClipOval(
                child: CustomImageWidget(
                  imageUrl:
                      "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  semanticLabel:
                      "Profile photo of Jai Sri Ram, user with traditional attire",
                ),
              ),
            ),
          ),

          // App Logo
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_hospital',
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'Dhanvantari',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // Top Right Icons: Help & Notification
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Help Icon
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Help & Info'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome to Dhanvantri!'),
                          SizedBox(height: 12),
                          Text('• Tap the Feed tab to see health updates'),
                          Text('• Use Clips for short health videos'),
                          Text('• Visit Hospital for healthcare services'),
                          Text('• Share Moments with your community'),
                          Text('• Chat with doctors via ChitChat'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'help_outline',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              ),

              // Notification Bell
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pushNamed('/notifications-screen');
                    },
                    icon: CustomIconWidget(
                      iconName: 'notifications_outlined',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        labelStyle: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'For You'),
          Tab(text: 'Following'),
        ],
      ),
    );
  }

  Widget _buildFeedList(ThemeData theme) {
    if (feedPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'article_outlined',
              color: theme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No posts yet',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share healthcare tips',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showPostCreationModal,
              icon: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: const Text('Create Post'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: feedPosts.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 100)),
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
          child: FeedCardWidget(
            post: feedPosts[index],
            onLike: () =>
                _handlePostAction(feedPosts[index]["id"] as int, 'like'),
            onComment: () =>
                _handlePostAction(feedPosts[index]["id"] as int, 'comment'),
            onShare: () =>
                _handlePostAction(feedPosts[index]["id"] as int, 'share'),
            onContextMenu: (action) =>
                _handlePostContextMenu(feedPosts[index]["id"] as int, action),
          ),
        );
      },
    );
  }
}
