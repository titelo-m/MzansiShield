import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        context.go('/');
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
    const Color cyberRed = Color(0xFFD32F2F);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        cyberRed.withOpacity(0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 240,
                    color: cyberRed,
                  ),
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFE0E0E0),
                      Color(0xFF757575),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: Text(
                    'MzansiShield',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SECURE. VERIFY. PROTECT.',
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 14,
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 70),
                SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: Color(0xFF1A1D24),
                      valueColor: AlwaysStoppedAnimation<Color>(cyberRed),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}