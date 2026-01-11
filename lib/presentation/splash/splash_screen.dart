import 'package:flutter/services.dart';

import '../../core/app_export.dart';

/// Splash Screen - Branded app launch experience with healthcare service initialization
///
/// Displays full-screen medical-themed splash with logo animation while performing
/// critical background tasks: authentication check, health preferences loading,
/// medical facility data fetch, and prescription cache preparation.
///
/// Navigation logic:
/// - Authenticated users → Feed tab
/// - New users → Medical onboarding flow
/// - Returning users → Login screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _pulseAnimation;

  bool _isInitializing = true;
  bool _hasError = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  static const Duration _splashDuration =
      Duration(seconds: 2); // Reduced for mock mode
  static const Duration _timeoutDuration =
      Duration(seconds: 10); // Increased timeout for mock mode

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  /// Setup logo and loading animations
  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Logo scale animation - subtle zoom effect
    _logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Logo opacity animation - fade in effect
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Pulse animation for loading indicator
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _animationController.repeat(reverse: true);
  }

  /// Initialize app with background tasks and navigation logic
  Future<void> _initializeApp() async {
    try {
      setState(() {
        _isInitializing = true;
        _hasError = false;
      });

      // Simulate critical background tasks with timeout
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserHealthPreferences(),
        _fetchMedicalFacilityData(),
        _prepareCachedPrescriptions(),
      ]).timeout(
        _timeoutDuration,
        onTimeout: () {
          throw TimeoutException('Initialization timeout');
        },
      );

      // Ensure minimum splash display time for branding
      await Future.delayed(_splashDuration);

      if (!mounted) return;

      // Navigation logic based on authentication status
      await _navigateToNextScreen();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _hasError = true;
        _isInitializing = false;
      });

      // Auto-retry logic
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _initializeApp();
        }
      }
    }
  }

  /// Check user authentication status (MOCK MODE - No backend required)
  Future<void> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // MOCK: Simulating auth check without backend
    // Backend integration: Uncomment when API is ready
    // final isAuthenticated = await AuthService.checkAuth();
  }

  /// Load user health preferences from local storage (MOCK MODE)
  Future<void> _loadUserHealthPreferences() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // MOCK: Using default preferences
    // Backend integration: Uncomment when API is ready
    // final preferences = await PreferencesService.loadHealthPreferences();
  }

  /// Fetch medical facility data for quick access (MOCK MODE)
  Future<void> _fetchMedicalFacilityData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    // MOCK: Using dummy facility data
    // Backend integration: Uncomment when API is ready
    // final facilities = await MedicalService.fetchNearbyFacilities();
  }

  /// Prepare cached prescription information for offline access (MOCK MODE)
  Future<void> _prepareCachedPrescriptions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // MOCK: No prescriptions cached
    // Backend integration: Uncomment when API is ready
    // await PrescriptionService.prepareCacheData();
  }

  /// Navigate to appropriate screen based on user state
  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    // MOCK MODE: Using mock data, no backend required
    // Navigate to login screen (all data is mocked)
    // Once backend is ready, implement actual authentication check here

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed(AppRoutes.login);
  }

  /// Retry initialization after error
  void _retryInitialization() {
    _retryCount = 0;
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Set system UI overlay style to match medical green theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: theme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.8),
              Colors.white,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child:
              _hasError ? _buildErrorView(theme) : _buildSplashContent(theme),
        ),
      ),
    );
  }

  /// Build main splash content with logo and loading indicator
  Widget _buildSplashContent(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // Animated logo with medical cross icon
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _logoOpacityAnimation.value,
              child: Transform.scale(
                scale: _logoScaleAnimation.value,
                child: _buildLogo(theme),
              ),
            );
          },
        ),

        const SizedBox(height: 48),

        // App name with medical tagline
        Text(
          'DHANVANTARI',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Your Healthcare Companion',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
        ),

        const Spacer(flex: 2),

        // Loading indicator with pulse animation
        if (_isInitializing) _buildLoadingIndicator(theme),

        const SizedBox(height: 48),
      ],
    );
  }

  /// Build logo with medical cross icon
  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'local_hospital',
          color: theme.colorScheme.primary,
          size: 64,
        ),
      ),
    );
  }

  /// Build loading indicator with pulse animation
  Widget _buildLoadingIndicator(ThemeData theme) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 3,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build error view with retry option
  Widget _buildErrorView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomIconWidget(
              iconName: 'error_outline',
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 24),
            Text(
              'Connection Error',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to initialize healthcare services. Please check your internet connection and try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _retryInitialization,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'refresh',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Retry',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_retryCount > 0)
              Text(
                'Retry attempt $_retryCount of $_maxRetries',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Custom exception for initialization timeout
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
