import 'dart:async';
import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/network/token_storage.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  Future<void> _navigateAfterSplash() async {
    final token = await TokenStorage.getAccessToken();
    if (!mounted) return;

    final nextRoute = (token != null && token.isNotEmpty)
        ? MyRoutes.homeScreen
        : MyRoutes.signup;

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();

    // After splash animation, continue based on saved auth state.
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            _navigateAfterSplash();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageLinks.appIcon, width: 160, height: 160),
              const SizedBox(height: 20),
              const Text(
                'TherapyApp',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Profissional support any time, anywhere',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
