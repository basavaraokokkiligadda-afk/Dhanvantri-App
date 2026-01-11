import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';

/// Calendar widget for selecting appointment dates with availability indicators
class CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime focusedDate;
  final Function(DateTime, DateTime) onDaySelected;
  final Map<DateTime, String> availabilityMap;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.focusedDate,
    required this.onDaySelected,
    required this.availabilityMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 90)),
            focusedDay: focusedDate,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: onDaySelected,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableGestures: AvailableGestures.horizontalSwipe,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle:
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ) ??
                  const TextStyle(),
              leftChevronIcon: CustomIconWidget(
                iconName: 'chevron_left',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              rightChevronIcon: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle:
                  theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ) ??
                  const TextStyle(),
              weekendStyle:
                  theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ) ??
                  const TextStyle(),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayTextStyle:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ) ??
                  const TextStyle(),
              selectedTextStyle:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ) ??
                  const TextStyle(),
              defaultTextStyle:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ) ??
                  const TextStyle(),
              weekendTextStyle:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ) ??
                  const TextStyle(),
              outsideTextStyle:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                  ) ??
                  const TextStyle(),
              disabledTextStyle:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.3,
                    ),
                  ) ??
                  const TextStyle(),
              markerDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _buildDayCell(context, day, false);
              },
              selectedBuilder: (context, day, focusedDay) {
                return _buildDayCell(context, day, true);
              },
              todayBuilder: (context, day, focusedDay) {
                return _buildDayCell(context, day, false, isToday: true);
              },
            ),
          ),
          SizedBox(height: 2.h),
          _buildAvailabilityLegend(context),
        ],
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    bool isSelected, {
    bool isToday = false,
  }) {
    final theme = Theme.of(context);
    final availability = _getAvailability(day);

    Color indicatorColor;
    if (availability == 'available') {
      indicatorColor = const Color(0xFF10B981);
    } else if (availability == 'limited') {
      indicatorColor = const Color(0xFFF59E0B);
    } else {
      indicatorColor = const Color(0xFFEF4444);
    }

    return Container(
      margin: EdgeInsets.all(0.5.w),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : isToday
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        shape: BoxShape.circle,
        border: isToday && !isSelected
            ? Border.all(color: theme.colorScheme.primary, width: 1.5)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              '${day.day}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : isToday
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected || isToday
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
          if (!isSelected)
            Positioned(
              bottom: 1.h,
              child: Container(
                width: 1.5.w,
                height: 1.5.w,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LegendItem(
          color: const Color(0xFF10B981),
          label: 'Available',
          theme: theme,
        ),
        _LegendItem(
          color: const Color(0xFFF59E0B),
          label: 'Limited',
          theme: theme,
        ),
        _LegendItem(
          color: const Color(0xFFEF4444),
          label: 'Unavailable',
          theme: theme,
        ),
      ],
    );
  }

  String _getAvailability(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return availabilityMap[normalizedDay] ?? 'available';
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final ThemeData theme;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
