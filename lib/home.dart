import 'package:flutter/material.dart';
import 'package:portfolio_flutter/background_pattern.dart';
import 'package:portfolio_flutter/bubble.dart';
import 'package:portfolio_flutter/centered_portfolio_with_backgound.dart';
import 'package:portfolio_flutter/experience_page.dart';
import 'package:portfolio_flutter/hero_section.dart';
import 'package:portfolio_flutter/project_grid.dart';
import 'package:portfolio_flutter/skill_card.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  final void Function() toggleTheme;
  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ExperiencePage(),
      body: CenteredPortfolioLayout(
        name: "Ahmed Saad",
        title: "Full Stack Developer",
      ),
      floatingActionButton: Stack(children: [
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
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'theme',
                onPressed: widget.toggleTheme,
                child: const Icon(Icons.brightness_6),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
