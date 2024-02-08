import 'package:flutter/material.dart';

class HomeNavigationButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final VoidCallback onTap;

  const HomeNavigationButton({
    super.key,
    required this.title,
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                Icon(
                  icon,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ],
            ),
            Text(
              count.toString(),
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
