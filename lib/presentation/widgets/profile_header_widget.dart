import 'package:animated_digit/animated_digit.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Avatar
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.onPrimary,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl:
                        'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                    semanticLabel:
                        'Profile photo of a middle-aged Indian man with short black hair and a warm smile, wearing traditional attire',
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jai Sri Ram',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'cake_outlined',
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.9,
                          ),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '34 years',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on_outlined',
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.9,
                          ),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Andhra Pradesh',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Health Score Indicator
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'favorite',
                      color: theme.colorScheme.onPrimary,
                      size: 28,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '85',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Health',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.9,
                        ),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Social Stats
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSocialStat(
                  context,
                  'Followers',
                  1247,
                  theme.colorScheme.onPrimary,
                ),
                Container(
                  width: 1,
                  height: 4.h,
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                ),
                _buildSocialStat(
                  context,
                  'Following',
                  892,
                  theme.colorScheme.onPrimary,
                ),
                Container(
                  width: 1,
                  height: 4.h,
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                ),
                _buildSocialStat(
                  context,
                  'Posts',
                  156,
                  theme.colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialStat(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AnimatedDigitWidget(
          value: value,
          textStyle:
              theme.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ) ??
              TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
          fractionDigits: 0,
          enableSeparator: true,
          separateSymbol: ',',
          separateLength: 3,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOut,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}
