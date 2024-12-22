import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    required this.title,
    this.showBackButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
            )
          : null,
      actions: [
        IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: context.read<ThemeProvider>().toggleTheme,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
