import 'package:flutter/material.dart';

class LycheeScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  const LycheeScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
