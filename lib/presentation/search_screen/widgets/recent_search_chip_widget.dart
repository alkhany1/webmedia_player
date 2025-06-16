import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RecentSearchChipWidget extends StatelessWidget {
  final String search;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const RecentSearchChipWidget({
    super.key,
    required this.search,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                search,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                ),
                textDirection: TextDirection.rtl,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            CustomIconWidget(
              iconName: 'history',
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
