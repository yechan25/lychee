// lib/widgets/problem_preview_card.dart
import 'package:flutter/material.dart';

class ProblemPreviewCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Widget? thumbnail;

  const ProblemPreviewCard({
    super.key,
    required this.title,
    this.onTap,
    this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child:
                  thumbnail ??
                  Container(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: theme.colorScheme.surface,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
