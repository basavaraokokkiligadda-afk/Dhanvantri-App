import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../core/app_export.dart';
import '../widgets/comment_bottom_sheet_widget.dart';
import '../widgets/context_menu_widget.dart';
import '../widgets/mood_filter_chips_widget.dart';
import '../widgets/share_bottom_sheet_widget.dart';
import '../widgets/video_action_panel_widget.dart';
import '../widgets/video_metadata_widget.dart';

class ClicksVideoFeed extends StatefulWidget {
  const ClicksVideoFeed({super.key});

  @override
  State<ClicksVideoFeed> createState() => _ClicksVideoFeedState();
}

class _ClicksVideoFeedState extends State<ClicksVideoFeed>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentVideoIndex = 0;
  String _selectedMoodFilter = 'Daily News';
  bool _isLiked = false;
  late AnimationController _likeAnimationController;

  final List<Map<String, dynamic>> _videoData = [
    {
      "id": 1,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "creatorName": "Dr. Rajesh Kumar",
      "credentials": "MBBS, MD - Cardiology",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1faf6faf8-1763294988170.png",
      "semanticLabel":
          "Profile photo of a middle-aged Indian male doctor with short black hair and glasses, wearing a white coat",
      "description":
          "Understanding Heart Health: Essential tips for maintaining cardiovascular wellness in your daily routine",
      "hashtags": ["#HeartHealth", "#Cardiology", "#HealthTips", "#DailyNews"],
      "likes": 2847,
      "comments": 156,
      "shares": 89,
      "isFollowing": false,
      "mood": "Daily News",
    },
    {
      "id": 2,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "creatorName": "Dr. Priya Sharma",
      "credentials": "MBBS, MS - General Surgery",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_19c27b25f-1763300463391.png",
      "semanticLabel":
          "Profile photo of a young Indian female doctor with long black hair tied back, wearing blue scrubs and smiling",
      "description":
          "Funny Medical Moments: When patients say the most unexpected things during consultations 😂",
      "hashtags": ["#MedicalHumor", "#DoctorLife", "#Comedy", "#Healthcare"],
      "likes": 5621,
      "comments": 342,
      "shares": 234,
      "isFollowing": true,
      "mood": "Comedy",
    },
    {
      "id": 3,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      "creatorName": "Dr. Amit Patel",
      "credentials": "MBBS, MD - Pediatrics",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_14f1cfca4-1763294024030.png",
      "semanticLabel":
          "Profile photo of an Indian male pediatrician with short hair and a friendly smile, wearing a light blue shirt",
      "description":
          "Complete Guide to Child Vaccination: Everything parents need to know about immunization schedules",
      "hashtags": [
        "#Pediatrics",
        "#Vaccination",
        "#ChildHealth",
        "#Educational",
      ],
      "likes": 4123,
      "comments": 287,
      "shares": 456,
      "isFollowing": false,
      "mood": "Educational",
    },
    {
      "id": 4,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      "creatorName": "Dr. Meera Reddy",
      "credentials": "MBBS, MD - Psychiatry",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1522092f5-1763298911814.png",
      "semanticLabel":
          "Profile photo of an Indian female psychiatrist with shoulder-length hair, wearing professional attire and a compassionate expression",
      "description":
          "Coping with Loss: A heartfelt message about dealing with grief and finding support during difficult times",
      "hashtags": ["#MentalHealth", "#Grief", "#Support", "#Sad"],
      "likes": 1876,
      "comments": 423,
      "shares": 167,
      "isFollowing": true,
      "mood": "Sad",
    },
    {
      "id": 5,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      "creatorName": "Dr. Vikram Singh",
      "credentials": "MBBS, MD - Emergency Medicine",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_18524814a-1763294483562.png",
      "semanticLabel":
          "Profile photo of an Indian male emergency doctor with a beard, wearing green scrubs and looking confident",
      "description":
          "Breaking: New guidelines released for emergency cardiac care protocols in Indian hospitals",
      "hashtags": ["#Emergency", "#Healthcare", "#News", "#DailyNews"],
      "likes": 3456,
      "comments": 198,
      "shares": 312,
      "isFollowing": false,
      "mood": "Daily News",
    },
    {
      "id": 6,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
      "creatorName": "Dr. Sneha Iyer",
      "credentials": "MBBS, MD - Dermatology",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_13fb03c6f-1763293719289.png",
      "semanticLabel":
          "Profile photo of an Indian female dermatologist with curly hair, wearing a white coat and smiling warmly",
      "description":
          "When patients Google their symptoms before coming to the clinic 🤦‍♀️ The reality vs expectation!",
      "hashtags": ["#DoctorHumor", "#Comedy", "#Dermatology", "#Relatable"],
      "likes": 6789,
      "comments": 567,
      "shares": 445,
      "isFollowing": true,
      "mood": "Comedy",
    },
    {
      "id": 7,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
      "creatorName": "Dr. Arjun Nair",
      "credentials": "MBBS, MS - Orthopedics",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_14dd7f408-1763293720007.png",
      "semanticLabel":
          "Profile photo of an Indian male orthopedic surgeon with short hair, wearing surgical scrubs and a serious expression",
      "description":
          "Comprehensive Tutorial: Proper posture and ergonomics for preventing back pain in office workers",
      "hashtags": ["#Orthopedics", "#BackPain", "#Educational", "#Prevention"],
      "likes": 5234,
      "comments": 312,
      "shares": 389,
      "isFollowing": false,
      "mood": "Educational",
    },
    {
      "id": 8,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
      "creatorName": "Dr. Kavita Desai",
      "credentials": "MBBS, MD - Oncology",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_15f3884bb-1763301318496.png",
      "semanticLabel":
          "Profile photo of an Indian female oncologist with glasses and short hair, wearing a white coat with a stethoscope",
      "description":
          "A touching story of hope and resilience: Cancer survivor shares their journey and message of strength",
      "hashtags": ["#CancerAwareness", "#Hope", "#Survivor", "#Sad"],
      "likes": 2345,
      "comments": 678,
      "shares": 234,
      "isFollowing": true,
      "mood": "Sad",
    },
  ];

  final List<VideoPlayerController> _videoControllers = [];
  List<Map<String, dynamic>> _filteredVideos = [];

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _filterVideos(_selectedMoodFilter);
    _initializeVideoControllers();
  }

  void _filterVideos(String mood) {
    setState(() {
      _selectedMoodFilter = mood;
      _filteredVideos = _videoData
          .where((video) => video["mood"] == mood)
          .toList();
    });
  }

  Future<void> _initializeVideoControllers() async {
    for (var controller in _videoControllers) {
      await controller.dispose();
    }
    _videoControllers.clear();

    for (var video in _filteredVideos) {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(video["videoUrl"] as String),
      );
      await controller.initialize();
      controller.setLooping(true);
      _videoControllers.add(controller);
    }

    if (_videoControllers.isNotEmpty) {
      _videoControllers[0].play();
    }
    setState(() {});
  }

  void _onPageChanged(int index) {
    if (_currentVideoIndex < _videoControllers.length) {
      _videoControllers[_currentVideoIndex].pause();
    }

    setState(() {
      _currentVideoIndex = index;
    });

    if (index < _videoControllers.length) {
      _videoControllers[index].play();
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _filteredVideos[_currentVideoIndex]["likes"] =
            (_filteredVideos[_currentVideoIndex]["likes"] as int) + 1;
        _likeAnimationController.forward().then((_) {
          _likeAnimationController.reverse();
        });
      } else {
        _filteredVideos[_currentVideoIndex]["likes"] =
            (_filteredVideos[_currentVideoIndex]["likes"] as int) - 1;
      }
    });
    HapticFeedback.mediumImpact();
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentBottomSheetWidget(
        videoId: _filteredVideos[_currentVideoIndex]["id"] as int,
        commentCount: _filteredVideos[_currentVideoIndex]["comments"] as int,
      ),
    );
  }

  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareBottomSheetWidget(
        videoData: _filteredVideos[_currentVideoIndex],
      ),
    );
  }

  void _showContextMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenuWidget(
        videoData: _filteredVideos[_currentVideoIndex],
        onFollowToggle: () {
          setState(() {
            _filteredVideos[_currentVideoIndex]["isFollowing"] =
                !(_filteredVideos[_currentVideoIndex]["isFollowing"] as bool);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _likeAnimationController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          color: theme.colorScheme.surface,
          child: SafeArea(
            bottom: false,
            child: MoodFilterChipsWidget(
              selectedMood: _selectedMoodFilter,
              onMoodSelected: (mood) {
                _filterVideos(mood);
                _initializeVideoControllers();
              },
            ),
          ),
        ),
        Expanded(
          child: _videoControllers.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                )
              : PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: _onPageChanged,
                  itemCount: _filteredVideos.length,
                  itemBuilder: (context, index) {
                    if (index >= _videoControllers.length) {
                      return const SizedBox.shrink();
                    }

                    return GestureDetector(
                      onDoubleTap: _toggleLike,
                      onLongPress: _showContextMenu,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          VideoPlayer(_videoControllers[index]),

                          AnimatedBuilder(
                            animation: _likeAnimationController,
                            builder: (context, child) {
                              return _likeAnimationController.value > 0
                                  ? Center(
                                      child: Transform.scale(
                                        scale:
                                            1.0 +
                                            (_likeAnimationController.value *
                                                2),
                                        child: Opacity(
                                          opacity:
                                              1.0 -
                                              _likeAnimationController.value,
                                          child: const CustomIconWidget(
                                            iconName: 'favorite',
                                            color: Colors.white,
                                            size: 100,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),

                          Positioned(
                            left: 16,
                            bottom: 80,
                            right: 80,
                            child: VideoMetadataWidget(
                              videoData: _filteredVideos[index],
                            ),
                          ),

                          Positioned(
                            right: 8,
                            bottom: 80,
                            child: VideoActionPanelWidget(
                              videoData: _filteredVideos[index],
                              isLiked: _isLiked,
                              onLikeTap: _toggleLike,
                              onCommentTap: _showCommentSheet,
                              onShareTap: _showShareSheet,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
