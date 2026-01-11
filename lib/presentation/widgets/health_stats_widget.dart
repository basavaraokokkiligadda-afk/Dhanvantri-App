
import '../../../core/app_export.dart';

class HealthStatsWidget extends StatelessWidget {
  const HealthStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> healthStats = [
      {
        'icon': 'monitor_heart',
        'label': 'Heart Rate',
        'value': '72 bpm',
        'color': theme.colorScheme.error,
      },
      {
        'icon': 'bloodtype',
        'label': 'Blood Group',
        'value': 'O+',
        'color': theme.colorScheme.primary,
      },
      {
        'icon': 'scale',
        'label': 'Weight',
        'value': '75 kg',
        'color': theme.colorScheme.secondary,
      },
      {
        'icon': 'height',
        'label': 'Height',
        'value': '175 cm',
        'color': theme.colorScheme.tertiary,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.5,
      ),
      itemCount: healthStats.length,
      itemBuilder: (context, index) {
        final stat = healthStats[index];
        return Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: (stat['color'] as Color).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: stat['icon'] as String,
                  color: stat['color'] as Color,
                  size: 28,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                stat['value'] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                stat['label'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
