import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../widgets/biometric_login_widget.dart';
import '../widgets/logo_section_widget.dart';
import '../widgets/otp_input_widget.dart';
import '../widgets/phone_input_widget.dart';

/// Login Screen for DHANVANTARI healthcare application
/// Implements secure authentication with medical-grade security
/// Supports phone number + OTP and biometric login methods
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isOtpSent = false;
  bool _isLoading = false;
  String? _phoneError;
  String? _otpError;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'phone': '9876543210',
    'otp': '123456',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool _validatePhoneNumber(String phone) {
    if (phone.isEmpty) {
      setState(() => _phoneError = 'Phone number is required');
      return false;
    }
    if (phone.length != 10) {
      setState(() => _phoneError = 'Phone number must be 10 digits');
      return false;
    }
    setState(() => _phoneError = null);
    return true;
  }

  bool _validateOtp(String otp) {
    if (otp.isEmpty) {
      setState(() => _otpError = 'OTP is required');
      return false;
    }
    if (otp.length != 6) {
      setState(() => _otpError = 'OTP must be 6 digits');
      return false;
    }
    setState(() => _otpError = null);
    return true;
  }

  Future<void> _sendOtp() async {
    if (!_validatePhoneNumber(_phoneController.text)) return;

    setState(() => _isLoading = true);

    // Simulate OTP sending
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isOtpSent = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent to +91 ${_phoneController.text}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _verifyOtpAndLogin() async {
    if (!_validateOtp(_otpController.text)) return;

    setState(() => _isLoading = true);

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_phoneController.text == _mockCredentials['phone'] &&
        _otpController.text == _mockCredentials['otp']) {
      // Success - trigger haptic feedback
      HapticFeedback.mediumImpact();

      if (mounted) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushReplacementNamed('/user-dashboard');
      }
    } else {
      setState(() {
        _isLoading = false;
        _otpError =
            'Invalid OTP. Please try again.\nTest credentials: Phone: ${_mockCredentials['phone']}, OTP: ${_mockCredentials['otp']}';
      });
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() => _isLoading = true);

    // Simulate biometric authentication
    await Future.delayed(const Duration(seconds: 1));

    // Success - trigger haptic feedback
    HapticFeedback.mediumImpact();

    if (mounted) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushReplacementNamed('/user-dashboard');
    }
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 4.h),

                  // Logo section
                  const LogoSectionWidget(),

                  SizedBox(height: 6.h),

                  // Welcome text
                  Text(
                    'Welcome Back',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Login to access your healthcare services',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4.h),

                  // Phone number input
                  PhoneInputWidget(
                    controller: _phoneController,
                    onChanged: (value) {
                      if (_phoneError != null) {
                        setState(() => _phoneError = null);
                      }
                    },
                    errorText: _phoneError,
                  ),

                  SizedBox(height: 3.h),

                  // OTP input (shown after phone verification)
                  if (_isOtpSent) ...[
                    OtpInputWidget(
                      controller: _otpController,
                      onCompleted: (otp) => _verifyOtpAndLogin(),
                      errorText: _otpError,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _isOtpSent = false;
                                    _otpController.clear();
                                    _otpError = null;
                                  });
                                },
                          child: Text(
                            'Change Number',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _isLoading ? null : _sendOtp,
                          child: Text(
                            'Resend OTP',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  SizedBox(height: 4.h),

                  // Login button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : (_isOtpSent ? _verifyOtpAndLogin : _sendOtp),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 2.5.h,
                            width: 2.5.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            _isOtpSent ? 'Verify & Login' : 'Send OTP',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),

                  SizedBox(height: 4.h),

                  // Biometric login option
                  if (!_isOtpSent)
                    BiometricLoginWidget(
                      onTap: _isLoading ? () {} : _handleBiometricLogin,
                    ),

                  SizedBox(height: 4.h),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New to DHANVANTARI? ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: _navigateToSignUp,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Medical disclaimer
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomIconWidget(
                          iconName: 'info_outline',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Your medical data is protected with end-to-end encryption and complies with healthcare privacy regulations.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
