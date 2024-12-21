import 'package:flutter/material.dart';
import 'package:portfolio_flutter/background_pattern.dart';
import 'dart:math' as math;

class HeroSection extends StatelessWidget {
  final double size;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;

  const HeroSection({
    required this.size,
    required this.scaleAnimation,
    required this.fadeAnimation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: HeroContainer(
            size: size,
            child: const HeroContent(),
          ),
        ),
      ),
    );
  }
}

class HeroContainer extends StatelessWidget {
  final double size;
  final Widget child;

  const HeroContainer({
    required this.size,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      padding: const EdgeInsets.all(32),
      decoration: _buildDecoration(context),
      child: child,
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).primaryColor.withValues(alpha: 0.15),
          Theme.of(context).primaryColor.withValues(alpha: 0.05),
        ],
      ),
      border: Border.all(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          blurRadius: 20,
          spreadRadius: 5,
        ),
      ],
    );
  }
}

class HeroContent extends StatelessWidget {
  const HeroContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientText(
          'Let\'s Build Something Amazing Together!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        const HeroSkillsList(),
      ],
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const GradientText(this.text, {this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).colorScheme.secondary,
        ],
      ).createShader(bounds),
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class HeroSkillsList extends StatelessWidget {
  const HeroSkillsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 8),
        SkillItem(
          icon: Icons.code,
          text: 'Web Development',
        ),
        SizedBox(height: 8),
        SkillItem(
          icon: Icons.mobile_friendly,
          text: 'Mobile Apps',
        ),
      ],
    );
  }
}

class SkillItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const SkillItem({
    required this.icon,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
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

class NavigationBubbleWidget extends StatelessWidget {
  final NavigationBubble bubble;
  final double size;

  const NavigationBubbleWidget({
    required this.bubble,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: bubble.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: _buildDecoration(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                bubble.icon,
                size: size * 0.3,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 8),
              Text(
                bubble.text,
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
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).primaryColor.withValues(alpha: 0.7),
          Theme.of(context).primaryColor.withValues(alpha: 0.4),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
          blurRadius: 15,
          spreadRadius: 5,
        ),
      ],
    );
  }
}

class OrbitingBubbles extends StatelessWidget {
  final List<NavigationBubble> bubbles;
  final List<Animation<double>> bubbleAnimations;
  final Animation<double> orbitAnimation;
  final double bubbleSize;
  final BoxConstraints constraints;

  const OrbitingBubbles({
    required this.bubbles,
    required this.bubbleAnimations,
    required this.orbitAnimation,
    required this.bubbleSize,
    required this.constraints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(bubbles.length, (index) {
        return AnimatedBuilder(
          animation: bubbleAnimations[index],
          builder: (context, child) {
            final position = _calculateBubblePosition(index);
            return Positioned(
              left: position.dx,
              top: position.dy,
              width: bubbleSize,
              height: bubbleSize,
              child: NavigationBubbleWidget(
                bubble: bubbles[index],
                size: bubbleSize,
              ),
            );
          },
        );
      }),
    );
  }

  Offset _calculateBubblePosition(int index) {
    final angle = (index / bubbles.length) * 2 * math.pi + (orbitAnimation.value * 2 * math.pi);
    final radius = (constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight) * 0.3;
    final dx = math.cos(angle) * radius;
    final dy = math.sin(angle) * radius;
    final bubbleAnimation = bubbleAnimations[index].value;

    return Offset(
      constraints.maxWidth / 2 + dx - bubbleSize / 2,
      constraints.maxHeight / 2 + dy - bubbleSize / 2 + (math.sin(bubbleAnimation * math.pi) * 20),
    );
  }
}

class CenteredPortfolioLayout extends StatefulWidget {
  const CenteredPortfolioLayout({super.key});

  @override
  State<CenteredPortfolioLayout> createState() => _CenteredPortfolioLayoutState();
}

class _CenteredPortfolioLayoutState extends State<CenteredPortfolioLayout> with TickerProviderStateMixin {
  late final AnimationController _heroController;
  late final AnimationController _bubblesController;
  late final AnimationController _backgroundController;
  late final List<AnimationController> _bubbleControllers;
  late final Animation<double> _fadeInAnimation;
  late final Animation<double> _scaleAnimation;
  late final List<Animation<double>> _bubbleAnimations;

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
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) => CustomPaint(
                painter: BackgroundPatternPainter(
                  rotation: _backgroundController.value * 2 * math.pi,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  HeroSection(
                    size: centerHeroSize,
                    scaleAnimation: _scaleAnimation,
                    fadeAnimation: _fadeInAnimation,
                  ),
                  OrbitingBubbles(
                    bubbles: bubbleItems,
                    bubbleAnimations: _bubbleAnimations,
                    orbitAnimation: _bubblesController,
                    bubbleSize: bubbleSize,
                    constraints: constraints,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
