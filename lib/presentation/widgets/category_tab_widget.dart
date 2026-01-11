import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoryTabWidget extends StatelessWidget {
  final List<String> categories;
  final TabController controller;
  final Function(int) onTabChanged;

  const CategoryTabWidget({
    super.key,
    required this.categories,
    required this.controller,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 7.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        indicatorColor: theme.colorScheme.primary,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorWeight: 3.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: Colors.transparent,
        onTap: onTabChanged,
        tabs: categories
            .map((category) => Tab(text: category, height: 6.h))
            .toList(),
      ),
    );
  }
}
