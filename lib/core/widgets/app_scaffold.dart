import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final bool useGradient;
  final List<Widget>? actions;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.drawer,
    this.floatingActionButton,
    this.useGradient = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (!useGradient) {
      return Scaffold(
        appBar: title != null
            ? AppBar(title: Text(title!), actions: actions)
            : null,
        drawer: drawer,
        floatingActionButton: floatingActionButton,
        body: body,
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryLight, AppColors.primary],
          ),
        ),
        child: title != null ? SafeArea(child: body) : body,
      ),
    );
  }
}
