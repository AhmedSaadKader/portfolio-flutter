import 'package:flutter/material.dart';
import 'package:portfolio_flutter/background_pattern.dart';
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
      body: Stack(
        children: [
          // Animated background pattern
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return CustomPaint(
                  painter:
                      BackgroundPatternPainter(rotation: _rotationController.value * 2 * math.pi, context: context),
                );
              },
            ),
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      "Hello, I'm\n Ahmed Saad",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'Full Stack Developer',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SkillCard(
                    icon: Icons.code,
                    title: 'Development',
                    skills: ['Flutter', 'React', 'Node.js', 'Python'],
                  ),
                  const SizedBox(height: 24),
                  ProjectsGrid(),
                ],
              ),
            ),
          ),
          // Floating action buttons
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
        ],
      ),
    );
  }
}
