import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int? selectedIndex;
  final int? currentIndex;
  final Function(int)? onItemSelected;
  final Function(int)? onTap;
  final List<BottomBarItem>? items;

  const CustomBottomBar({
    super.key,
    this.selectedIndex,
    this.currentIndex,
    this.onItemSelected,
    this.onTap,
    this.items,
  });

  int _getSelectedIndex() => selectedIndex ?? currentIndex ?? 0;

  void _handleItemTap(int index) {
    onItemSelected?.call(index);
    onTap?.call(index);
  }

  List<BottomBarItem> _getItems() {
    return items ??
        [
          const BottomBarItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Feed',
          ),
          const BottomBarItem(
            icon: Icons.video_library_outlined,
            activeIcon: Icons.video_library,
            label: 'Clips',
          ),
          const BottomBarItem(
            icon: Icons.local_hospital_outlined,
            activeIcon: Icons.local_hospital,
            label: 'Hospital',
            isCenter: true,
          ),
          const BottomBarItem(
            icon: Icons.auto_awesome_outlined,
            activeIcon: Icons.auto_awesome,
            label: 'Moments',
          ),
          const BottomBarItem(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            label: 'ChitChat',
          ),
        ];
  }

  @override
  Widget build(BuildContext context) {
    final itemsList = _getItems();
    final selected = _getSelectedIndex();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: itemsList.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = selected == index;

              // Center button (Hospital) - larger and special styling
              if (item.isCenter) {
                return InkWell(
                  onTap: () => _handleItemTap(index),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      item.activeIcon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                );
              }

              // Regular navigation items
              return InkWell(
                onTap: () => _handleItemTap(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class BottomBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isCenter;

  const BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isCenter = false,
  });
}
