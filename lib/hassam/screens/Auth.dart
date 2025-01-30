import 'package:flutter/material.dart';
import 'dart:math';

import 'LoginPage.dart';
import 'RegisterPage.dart'; // if you actually need to reference the original RegisterPage
// import 'SignUp.dart'; // if your app navigates to SignUp, adjust accordingly.

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _gradientController;
  late AnimationController _shapeController;
  late AnimationController _fadeController;

  // Gradient Animations
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  // Floating Shapes
  final List<AnimatedShape> _shapes = [];

  // Fade Animation
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1) Animated Gradient Controller
    _gradientController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: Colors.green.shade400,
      end: Colors.green.shade700,
    ).animate(_gradientController);

    _colorAnimation2 = ColorTween(
      begin: Colors.green.shade700,
      end: Colors.green.shade400,
    ).animate(_gradientController);

    // 2) Floating Shapes Controller
    _shapeController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Generate random shapes
    for (int i = 0; i < 5; i++) {
      _shapes.add(
        AnimatedShape(
          size: Random().nextDouble() * 40 + 20,
          color: Colors.white.withOpacity(0.1 + Random().nextDouble() * 0.2),
          speed: Random().nextDouble() * 40 + 20,
          direction: Random().nextBool() ? 1 : -1,
          position: Random().nextDouble(),
        ),
      );
    }

    // 3) Fade Controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Start the fade animation
    _fadeController.forward();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _shapeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Animated Gradient
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _colorAnimation1.value ?? Colors.green.shade400,
                  _colorAnimation2.value ?? Colors.green.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Floating Animated Shapes
                ..._shapes.map((shape) {
                  return Positioned(
                    left: MediaQuery.of(context).size.width *
                        shape.position *
                        shape.direction,
                    top: MediaQuery.of(context).size.height * 0.2,
                    child: AnimatedBuilder(
                      animation: _shapeController,
                      builder: (context, child) {
                        double offset = (sin(_shapeController.value * 2 * pi) *
                                20 /
                                shape.speed) *
                            shape.direction;
                        return Transform.translate(
                          offset: Offset(offset, 0),
                          child: child,
                        );
                      },
                      child: Container(
                        width: shape.size,
                        height: shape.size,
                        decoration: BoxDecoration(
                          color: shape.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),

                SafeArea(
                  child: SingleChildScrollView(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),

                            // Logo (Bouncy Icon)
                            Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.local_grocery_store,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Welcome Text
                            const Text(
                              "Welcome! Let's Login with your Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 30),

                            // Social Login Buttons
                            _buildSocialButton(
                              label: "Continue With Google",
                              icon: Icons.android, // example icon
                              onPressed: () {
                                // Handle Google Login
                              },
                            ),
                            const SizedBox(height: 20),

                            _buildSocialButton(
                              label: "Continue With Apple",
                              icon: Icons.apple,
                              onPressed: () {
                                // Handle Apple Login
                              },
                            ),
                            const SizedBox(height: 20),

                            _buildSocialButton(
                              label: "Continue With Facebook",
                              icon: Icons.facebook,
                              onPressed: () {
                                // Handle Facebook Login
                              },
                            ),
                            const SizedBox(height: 20),

                            _buildSocialButton(
                              label: "Continue With Twitter",
                              icon: Icons.alternate_email, // example icon
                              onPressed: () {
                                // Handle Twitter Login
                              },
                            ),

                            const SizedBox(height: 30),

                            // Divider
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 1,
                                  color: Colors.white54,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 1,
                                  color: Colors.white54,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Sign In with Password
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                "Sign In with Password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Sign Up
                            Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don’t Have an Account?",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Color(0xFF93C5FD),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper to Build Social Button
  Widget _buildSocialButton({
    required String label,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: const Size(double.infinity, 50),
        elevation: 0,
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------
// Floating shapes + data model below
// -----------------------------------
class AnimatedShape {
  final double size;
  final Color color;
  final double speed;
  final int direction; // 1 => moving right, -1 => moving left
  final double position;

  AnimatedShape({
    required this.size,
    required this.color,
    required this.speed,
    required this.direction,
    required this.position,
  });
}
