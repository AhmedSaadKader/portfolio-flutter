import 'package:flutter/material.dart';
import 'package:portfolio_flutter/centered_portfolio_with_backgound.dart';
import 'package:portfolio_flutter/custom_app_bar.dart';
import 'package:portfolio_flutter/floating_buttons.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _slideController;

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
      appBar: const CustomAppBar(
        title: 'Home',
        showBackButton: false,
      ),
      body: const CenteredPortfolioLayout(),
      floatingActionButton: FloatingActionButtons(),
    );
  }
}
