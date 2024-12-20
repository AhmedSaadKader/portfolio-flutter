import 'dart:math' as math;
import 'package:flutter/material.dart';

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

class BubbleAnimation extends StatefulWidget {
  final List<NavigationBubble> bubbleItems;
  final double minBubbleSize;
  final double maxBubbleSize;
  final double height; // Added height parameter

  const BubbleAnimation({
    Key? key,
    required this.bubbleItems,
    this.minBubbleSize = 150.0,
    this.maxBubbleSize = 200.0,
    this.height = 600.0, // Default height
  }) : super(key: key);

  @override
  State<BubbleAnimation> createState() => _BubbleAnimationState();
}

class _BubbleAnimationState extends State<BubbleAnimation> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Offset> _positions;
  late List<double> _sizes;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final random = math.Random();

    _controllers = List.generate(
      widget.bubbleItems.length,
      (index) => AnimationController(
        duration: Duration(seconds: 15 + random.nextInt(5)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Initialize positions with relative coordinates
    _positions = List.generate(
      widget.bubbleItems.length,
      (index) {
        final angle = (index / widget.bubbleItems.length) * 2 * math.pi;
        final radius = widget.height * 0.3; // Adjust radius based on height
        return Offset(
          math.cos(angle) * radius,
          math.sin(angle) * radius,
        );
      },
    );

    _sizes = List.generate(
      widget.bubbleItems.length,
      (index) => widget.minBubbleSize + random.nextDouble() * (widget.maxBubbleSize - widget.minBubbleSize),
    );

    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        _controllers[i]
          ..forward()
          ..repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: List.generate(widget.bubbleItems.length, (index) {
              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  final value = _animations[index].value;
                  final position = _positions[index];
                  final size = _sizes[index];

                  return Positioned(
                    left: constraints.maxWidth / 2 + position.dx + (math.sin(value * math.pi) * 30) - size / 2,
                    top: constraints.maxHeight / 2 + position.dy + (math.cos(value * math.pi) * 30) - size / 2,
                    width: size,
                    height: size,
                    child: GestureDetector(
                      onTap: widget.bubbleItems[index].onTap,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
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
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.bubbleItems[index].icon,
                                  size: size * 0.25,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.bubbleItems[index].text,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                    ),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }
}
