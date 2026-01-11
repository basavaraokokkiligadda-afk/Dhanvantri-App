
import '../../../core/app_export.dart';

class MedicalHistoryWidget extends StatelessWidget {
  const MedicalHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> medicalHistory = [
      {
        'type': 'Appointment',
        'title': 'Dr. Priya Sharma - Cardiologist',
        'date': '05/01/2026',
        'status': 'Completed',
        'icon': 'event_available',
        'color': theme.colorScheme.tertiary,
      },
      {
        'type': 'Prescription',
        'title': 'Blood Pressure Medication',
        'date': '05/01/2026',
        'status': 'Active',
        'icon': 'medication',
        'color': theme.colorScheme.primary,
      },
      {
        'type': 'Diagnostic',
        'title': 'Complete Blood Count Test',
        'date': '28/12/2025',
        'status': 'Report Available',
        'icon': 'science',
        'color': theme.colorScheme.secondary,
      },
      {
        'type': 'Appointment',
        'title': 'Dr. Rajesh Kumar - General Physician',
        'date': '15/12/2025',
        'status': 'Completed',
        'icon': 'event_available',
        'color': theme.colorScheme.tertiary,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(3.w),
        itemCount: medicalHistory.length,
        separatorBuilder: (context, index) => Divider(
          height: 3.h,
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        itemBuilder: (context, index) {
          final record = medicalHistory[index];
          return InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('View ${record['type']} details'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: (record['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: record['icon'] as String,
                      color: record['color'] as Color,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record['title'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              record['date'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.3.h,
                              ),
                              decoration: BoxDecoration(
                                color: (record['color'] as Color).withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                record['status'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: record['color'] as Color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
