import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../widgets/story_circle_widget.dart';
import '../widgets/create_story_modal_widget.dart';

class SnipStoriesScreen extends StatefulWidget {
  const SnipStoriesScreen({super.key});

  @override
  State<SnipStoriesScreen> createState() => _SnipStoriesScreenState();
}

class _SnipStoriesScreenState extends State<SnipStoriesScreen> {
  final List<Map<String, dynamic>> stories = [
    {
      'user': 'Dr. Sarah Johnson',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1fe03ce7b-1763294977207.png',
      'hasStory': true,
      'type': 'image',
      'storyCount': 3,
    },
    {
      'user': 'Health Tips',
      'imageUrl':
          'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d',
      'hasStory': true,
      'type': 'text',
      'storyCount': 2,
    },
    {
      'user': 'Medical Updates',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_19d7714ef-1763294958604.png',
      'hasStory': true,
      'type': 'image',
      'storyCount': 1,
    },
    {
      'user': 'Dr. Priya Sharma',
      'imageUrl': 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2',
      'hasStory': true,
      'type': 'voice',
      'storyCount': 2,
    },
    {
      'user': 'Wellness Center',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1ba95ba5e-1763300102901.png',
      'hasStory': true,
      'type': 'image',
      'storyCount': 4,
    },
    {
      'user': 'Yoga & Fitness',
      'imageUrl': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b',
      'hasStory': true,
      'type': 'image',
      'storyCount': 3,
    },
  ];

  void _showCreateStoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateStoryModalWidget(
        onStoryCreated: (story) {
          Navigator.pop(context);
          // Handle story creation
        },
      ),
    );
  }

  void _viewStory(int index) {
    final story = stories[index];
    final storyType = story['type'] as String;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            // Story Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (storyType == 'image')
                    Image.network(
                      story['imageUrl'],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.white,
                      ),
                    )
                  else if (storyType == 'text')
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'Stay hydrated! Drink at least 8 glasses of water daily for better health. 💧',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (storyType == 'voice')
                    Column(
                      children: [
                        const Icon(
                          Icons.mic,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Voice Story',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                '0:15',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            // Header
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(story['imageUrl']),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story['user'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '2 hours ago',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showCreateStoryModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stories row
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: stories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Add your story
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: _showCreateStoryModal,
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Your Story',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final story = stories[index - 1];
                  return StoryCircleWidget(
                    userName: story['user'],
                    userImage: story['imageUrl'] ?? '',
                    semanticLabel: story['user'],
                    isVerified: false,
                    hasUnviewedStory: story['hasStory'] ?? false,
                    onTap: () => _viewStory(index - 1),
                  );
                },
              ),
            ),
            const Divider(),
            // Main content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_stories,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Active Stories',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap a story circle to view',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
