import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Production-Grade Base Screen Widget
/// Eliminates UI anti-patterns with proper responsive layout
class BaseScreen extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showAppBar;
  final bool resizeToAvoidBottomInset;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final bool enableScroll;
  final EdgeInsets? padding;
  final PreferredSizeWidget? bottom;

  const BaseScreen({
    super.key,
    this.title,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showAppBar = true,
    this.resizeToAvoidBottomInset = true,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.enableScroll = true,
    this.padding,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    // Add padding if specified
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // Wrap in scroll if enabled (prevents overflow)
    if (enableScroll) {
      content = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: showAppBar
            ? AppBar(
                title: title != null ? Text(title!) : null,
                actions: actions,
                leading: leading,
                bottom: bottom,
              )
            : null,
        body: content,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
