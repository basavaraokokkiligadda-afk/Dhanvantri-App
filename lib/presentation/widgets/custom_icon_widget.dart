import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final IconData? icon;
  final String? iconName;
  final double? size;
  final Color? color;
  final VoidCallback? onTap;

  const CustomIconWidget({
    super.key,
    this.icon,
    this.iconName,
    this.size,
    this.color,
    this.onTap,
  }) : assert(icon != null || iconName != null,
            'Either icon or iconName must be provided');

  IconData _getIcon() {
    if (icon != null) return icon!;

    // Map common icon names to IconData
    final iconMap = <String, IconData>{
      'close': Icons.close,
      'menu': Icons.menu,
      'search': Icons.search,
      'arrow_back': Icons.arrow_back,
      'arrow_forward': Icons.arrow_forward,
      'add': Icons.add,
      'delete': Icons.delete,
      'edit': Icons.edit,
      'save': Icons.save,
      'settings': Icons.settings,
      'home': Icons.home,
      'person': Icons.person,
      'notifications': Icons.notifications,
      'favorite': Icons.favorite,
      'share': Icons.share,
      'more_vert': Icons.more_vert,
      'check': Icons.check,
      'info': Icons.info,
      'warning': Icons.warning,
      'error': Icons.error,
      'mic': Icons.mic,
      'send': Icons.send,
      'attach_file': Icons.attach_file,
      'camera': Icons.camera_alt,
      'gallery': Icons.photo_library,
      'location': Icons.location_on,
      'calendar': Icons.calendar_today,
      'phone': Icons.phone,
      'email': Icons.email,
      'language': Icons.language,
      'translate': Icons.translate,
    };

    return iconMap[iconName?.toLowerCase()] ?? Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(
      _getIcon(),
      size: size ?? 24,
      color: color ?? Theme.of(context).iconTheme.color,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: iconWidget,
        ),
      );
    }

    return iconWidget;
  }
}
