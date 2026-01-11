import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({super.key, required this.onApplyFilters});

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  RangeValues _priceRange = const RangeValues(0, 500);
  String _selectedType = 'All';
  String _selectedAvailability = 'All';
  String _selectedDelivery = 'All';

  final List<String> _typeOptions = ['All', 'Brand', 'Generic'];
  final List<String> _availabilityOptions = ['All', 'Prescription', 'OTC'];
  final List<String> _deliveryOptions = [
    'All',
    'Walking Pickup',
    'Instant 30min',
    'Standard 4-5 days',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _priceRange = const RangeValues(0, 500);
                          _selectedType = 'All';
                          _selectedAvailability = 'All';
                          _selectedDelivery = 'All';
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Price Range',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 500,
                  divisions: 50,
                  labels: RangeLabels(
                    '\$${_priceRange.start.round()}',
                    '\$${_priceRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${_priceRange.start.round()}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '\$${_priceRange.end.round()}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Medicine Type',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  children: _typeOptions.map((type) {
                    final isSelected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                      selectedColor: theme.colorScheme.primary.withValues(
                        alpha: 0.2,
                      ),
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Availability',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  children: _availabilityOptions.map((availability) {
                    final isSelected = _selectedAvailability == availability;
                    return ChoiceChip(
                      label: Text(availability),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedAvailability = availability;
                        });
                      },
                      selectedColor: theme.colorScheme.primary.withValues(
                        alpha: 0.2,
                      ),
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Delivery Options',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _deliveryOptions.map((delivery) {
                    final isSelected = _selectedDelivery == delivery;
                    return ChoiceChip(
                      label: Text(delivery),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedDelivery = delivery;
                        });
                      },
                      selectedColor: theme.colorScheme.primary.withValues(
                        alpha: 0.2,
                      ),
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters({
                        'priceRange': _priceRange,
                        'type': _selectedType,
                        'availability': _selectedAvailability,
                        'delivery': _selectedDelivery,
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
