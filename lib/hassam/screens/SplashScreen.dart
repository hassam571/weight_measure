import 'package:flutter/material.dart';
import 'dart:math';

// Replace this import with the file containing your RegisterPage
import 'Auth.dart'; // or wherever RegisterPage is located

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
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

  // Sample bullet points to highlight your app's features
  final List<String> _featurePoints = [
    "Fresh from local farms",
    "100% Organic produce",
    "Zero chemical usage",
    "Delivered to your doorstep",
  ];

  @override
  void initState() {
    super.initState();

    // 1) Animated Gradient Controller
    _gradientController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    // Two ColorTweens to produce a subtle color shift
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

    // Generate random shapes for subtle background animation
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

    // Start fading in
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
      // Animated gradient background
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
                ..._shapes.map(
                  (shape) => Positioned(
                    left: MediaQuery.of(context).size.width *
                        shape.position *
                        shape.direction,
                    // Slightly below the top for a nice effect
                    top: MediaQuery.of(context).size.height * 0.2,
                    child: AnimatedBuilder(
                      animation: _shapeController,
                      builder: (context, child) {
                        final offset = (sin(_shapeController.value * 2 * pi) *
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
                  ),
                ),

                // Main content with fade-in
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: 70),

                        // Logo (Optional)
                        // Replace this icon with your Image.asset if desired
                        Center(
                          child: Icon(
                            Icons.local_grocery_store,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Headline / Tagline
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Eat Organic for your well-being and health.',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.6),
                                  offset: const Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Extra static content to fill space:
                        const SizedBox(height: 20),
                        _buildFeaturesSection(),
                        const Spacer(),

                        // Get Started Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              // Replace with your actual register or home page
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),
                      ],
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

  // Builds a list of bullet points to showcase your app's features
  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: List.generate(_featurePoints.length, (index) {
          final feature = _featurePoints[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// Represents each floating shape in the background
class AnimatedShape {
  final double size;
  final Color color;
  final double speed;
  final int direction; // 1 => right, -1 => left
  final double position;

  AnimatedShape({
    required this.size,
    required this.color,
    required this.speed,
    required this.direction,
    required this.position,
  });
}
