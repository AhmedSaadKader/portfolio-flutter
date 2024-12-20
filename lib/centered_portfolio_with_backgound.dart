import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio_flutter/background_pattern.dart';

class CenteredPortfolioLayout extends StatefulWidget {
  final String name;
  final String title;

  const CenteredPortfolioLayout({
    Key? key,
    required this.name,
    required this.title,
  }) : super(key: key);

  @override
  State<CenteredPortfolioLayout> createState() => _CenteredPortfolioLayoutState();
}

class _CenteredPortfolioLayoutState extends State<CenteredPortfolioLayout> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _bubblesController;
  late AnimationController _backgroundController;
  late List<AnimationController> _bubbleControllers;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late List<Animation<double>> _bubbleAnimations;

  final List<NavigationBubble> bubbleItems = [
    NavigationBubble(
      text: 'Education',
      icon: Icons.school,
      onTap: () => print('Education clicked'),
    ),
    NavigationBubble(
      text: 'Projects',
      icon: Icons.work,
      onTap: () => print('Projects clicked'),
    ),
    NavigationBubble(
      text: 'Contact',
      icon: Icons.contact_mail,
      onTap: () => print('Contact clicked'),
    ),
    NavigationBubble(
      text: 'Skills',
      icon: Icons.code,
      onTap: () => print('Skills clicked'),
    ),
    NavigationBubble(
      text: 'About',
      icon: Icons.person,
      onTap: () => print('About clicked'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _bubblesController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
    ));

    _bubbleControllers = List.generate(
      bubbleItems.length,
      (index) => AnimationController(
        duration: Duration(seconds: 15 + index),
        vsync: this,
      )..repeat(reverse: true),
    );

    _bubbleAnimations = _bubbleControllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _bubblesController.dispose();
    _backgroundController.dispose();
    for (var controller in _bubbleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerHeroSize = math.min(constraints.maxWidth * 0.5, 400.0);
        final bubbleSize = math.min(constraints.maxWidth * 0.15, 150.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            // Animated background pattern
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundPatternPainter(
                    rotation: _backgroundController.value * 2 * math.pi,
                    context: context,
                  ),
                );
              },
            ),
            // Content container
            Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Centered Hero Section
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeInAnimation,
                        child: Container(
                          width: centerHeroSize,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).primaryColor.withOpacity(0.15),
                                Theme.of(context).primaryColor.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Welcome',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.name,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.code,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.title,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Orbiting Bubbles
                  ...List.generate(bubbleItems.length, (index) {
                    return AnimatedBuilder(
                      animation: _bubbleAnimations[index],
                      builder: (context, child) {
                        final angle =
                            (index / bubbleItems.length) * 2 * math.pi + (_bubblesController.value * 2 * math.pi);
                        final radius = (constraints.maxWidth < constraints.maxHeight
                                ? constraints.maxWidth
                                : constraints.maxHeight) *
                            0.3; // Use the smaller dimension for radius
                        final dx = math.cos(angle) * radius;
                        final dy = math.sin(angle) * radius;
                        final bubbleAnimation = _bubbleAnimations[index].value;

                        return Positioned(
                          left: constraints.maxWidth / 2 + dx - bubbleSize / 2,
                          top: constraints.maxHeight / 2 +
                              dy -
                              bubbleSize / 2 +
                              (math.sin(bubbleAnimation * math.pi) * 20),
                          width: bubbleSize,
                          height: bubbleSize,
                          child: GestureDetector(
                            onTap: bubbleItems[index].onTap,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Theme.of(context).primaryColor.withOpacity(0.7),
                                      Theme.of(context).primaryColor.withOpacity(0.4),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor.withOpacity(0.2),
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      bubbleItems[index].icon,
                                      size: bubbleSize * 0.3,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      bubbleItems[index].text,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class NavigationBubble {
  final String text;
  final VoidCallback onTap;
  final IconData icon;

  NavigationBubble({
    required this.text,
    required this.onTap,
    required this.icon,
  });
}
