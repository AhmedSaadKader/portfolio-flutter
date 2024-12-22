import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSlideTransition extends CustomTransitionPage<void> {
  CustomSlideTransition({
    required Widget child,
    required LocalKey key,
  }) : super(
          key: key,
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final curveTween = CurveTween(curve: Curves.easeInOut);
            return SlideTransition(
              position: animation.drive(curveTween).drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
          maintainState: true,
          opaque: true,
        );
}
