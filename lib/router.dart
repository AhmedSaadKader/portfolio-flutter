import 'package:flutter/material.dart';
import 'package:portfolio_flutter/custom_transition.dart';
import 'package:portfolio_flutter/education_page.dart';
import 'home.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CustomSlideTransition(
        child: HomePage(),
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/education',
      pageBuilder: (context, state) => CustomSlideTransition(
        child: PortfolioList(),
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/skills',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/about',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/projects',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/experience',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/contact',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
    ),
  ],
);
