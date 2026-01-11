import 'package:flutter/material.dart';

class TimeSlotSelector extends StatelessWidget {
  final List<String>? timeSlots;
  final String? selectedTime;
  final String? selectedTimeSlot;
  final Function(String)? onTimeSelected;
  final Function(String)? onTimeSlotSelected;

  const TimeSlotSelector({
    super.key,
    this.timeSlots,
    this.selectedTime,
    this.selectedTimeSlot,
    this.onTimeSelected,
    this.onTimeSlotSelected,
  });

  List<String> _getTimeSlots() {
    return timeSlots ??
        [
          '09:00 AM',
          '09:30 AM',
          '10:00 AM',
          '10:30 AM',
          '11:00 AM',
          '11:30 AM',
          '02:00 PM',
          '02:30 PM',
          '03:00 PM',
          '03:30 PM',
          '04:00 PM',
          '04:30 PM',
        ];
  }

  String? _getSelectedTime() {
    return selectedTime ?? selectedTimeSlot;
  }

  void _handleTimeSelection(String time) {
    onTimeSelected?.call(time);
    onTimeSlotSelected?.call(time);
  }

  @override
  Widget build(BuildContext context) {
    final slots = _getTimeSlots();
    final selected = _getSelectedTime();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Time Slots',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((time) {
              final isSelected = time == selected;
              return InkWell(
                onTap: () => _handleTimeSelection(time),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
