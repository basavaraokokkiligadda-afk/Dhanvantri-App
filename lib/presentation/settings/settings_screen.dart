import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';

/// Settings Screen with various app settings sections
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Account Section
          _buildSectionHeader(theme, 'Account'),
          _buildListTile(
            theme,
            icon: Icons.person_outline,
            title: 'Profile Information',
            subtitle: 'Update your name, email, and phone',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Profile Information');
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.security_outlined,
            title: 'Password & Security',
            subtitle: 'Change password and security settings',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Password & Security');
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.badge_outlined,
            title: 'Verification',
            subtitle: 'Verify your account with documents',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Verification');
            },
          ),

          const Divider(height: 32),

          // Privacy Section
          _buildSectionHeader(theme, 'Privacy'),
          _buildListTile(
            theme,
            icon: Icons.shield_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Privacy Policy');
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.article_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Terms of service',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Terms & Conditions');
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.visibility_outlined,
            title: 'Data Visibility',
            subtitle: 'Control who can see your data',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Data Visibility');
            },
          ),

          const Divider(height: 32),

          // Notifications Section
          _buildSectionHeader(theme, 'Notifications'),
          _buildSwitchTile(
            theme,
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: _notificationsEnabled,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _notificationsEnabled = value);
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.email_outlined,
            title: 'Email Notifications',
            subtitle: 'Manage email preferences',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Email Notifications');
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.sms_outlined,
            title: 'SMS Notifications',
            subtitle: 'Manage SMS alerts',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'SMS Notifications');
            },
          ),

          const Divider(height: 32),

          // App Settings Section
          _buildSectionHeader(theme, 'App Settings'),
          _buildSwitchTile(
            theme,
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            value: _darkModeEnabled,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _darkModeEnabled = value);
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English (Default)',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Language Settings');
            },
          ),
          _buildSwitchTile(
            theme,
            icon: Icons.fingerprint_outlined,
            title: 'Biometric Login',
            subtitle: 'Use fingerprint/face to login',
            value: _biometricEnabled,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _biometricEnabled = value);
            },
          ),

          const Divider(height: 32),

          // Help & Support Section
          _buildSectionHeader(theme, 'Help & Support'),
          _buildListTile(
            theme,
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'Get help with your account',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Help Center');
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.chat_bubble_outline,
            title: 'Contact Support',
            subtitle: 'Chat with our support team',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Contact Support');
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Help us improve the app',
            onTap: () {
              HapticFeedback.lightImpact();
              _showComingSoon(context, 'Send Feedback');
            },
          ),
          _buildListTile(
            theme,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {
              HapticFeedback.lightImpact();
              _showAboutDialog(context);
            },
          ),

          const SizedBox(height: 16),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                _showLogoutDialog(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Logout'),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildListTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Dhanvantri'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Your complete healthcare companion'),
            SizedBox(height: 8),
            Text('© 2026 Dhanvantri Healthcare'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
