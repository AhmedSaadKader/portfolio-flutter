import 'package:flutter/material.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:provider/provider.dart';

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        bottom: 32,
        right: 32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'github',
              onPressed: () {},
              child: const Icon(Icons.code),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'contact',
              onPressed: () {},
              child: const Icon(Icons.email),
            ),
          ],
        ),
      ),
    ]);
  }
}
