// lib/hassam/screens/ForgetPage.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Must be at the top
import 'dart:convert';
import 'dart:math';

// -----------------------------------------------
// EmailJS Credentials
// -----------------------------------------------
const String emailJsServiceId = 'service_an74vtp';
const String emailJsTemplateId = 'template_2w05xnd';
const String emailJsPublicKey = 'e97qtNK-7UU8B5ehR';

class ForgetPage extends StatefulWidget {
  @override
  _ForgetPageState createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();

  // Animation Controllers
  late AnimationController _gradientController;
  late AnimationController _shapeController;
  late AnimationController _fadeController;

  // Gradient Animations
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  // Floating Shapes
  final List<AnimatedShape> _shapes = [];

  // Fade-in Animation
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1) Animated Gradient
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

    // 2) Floating Shapes
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
          rotationSpeed: Random().nextDouble() * 2 + 0.5,
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
    _fadeController.forward();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _shapeController.dispose();
    _fadeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Send email via EmailJS's REST API
  Future<void> _sendEmailJS() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email address")),
      );
      return;
    }

    // Generate a random token
    final randomToken = Random().nextInt(999999);
    final resetLink = "https://yourapp.com/reset?token=$randomToken";

    // EmailJS endpoint
    final Uri url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    // JSON body for EmailJS
    final Map<String, dynamic> bodyData = {
      'service_id': emailJsServiceId,
      'template_id': emailJsTemplateId,
      'user_id': emailJsPublicKey,
      'template_params': {
        'user_email': email,
        'message': resetLink,
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        // success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Reset link sent to $email"),
          ),
        );
      } else {
        // Something went wrong from EmailJS side
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to send email: ${response.statusCode} ${response.body}",
            ),
          ),
        );
      }
    } catch (e) {
      // Network or other error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Network error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Animated gradient
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final color1 = _colorAnimation1.value ?? Colors.green.shade400;
          final color2 = _colorAnimation2.value ?? Colors.green.shade700;

          return Container(
            color: color1,
            child: Stack(
              children: [
                // Wave 
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 180),
                  painter: WavePainter(color: color2),
                ),

                // Floating shapes
                ..._shapes.map((shape) {
                  return AnimatedBuilder(
                    animation: _shapeController,
                    builder: (context, child) {
                      final t = _shapeController.value * 2 * pi;
                      final offset =
                          (sin(t) * 20 / shape.speed) * shape.direction;
                      final rotation = t * shape.rotationSpeed;

                      return Positioned(
                        left: MediaQuery.of(context).size.width *
                                shape.position *
                                shape.direction +
                            offset,
                        top: MediaQuery.of(context).size.height * 0.2,
                        child: Transform.rotate(
                          angle: rotation,
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
                    },
                  );
                }),

                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "AppBar"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Title
                          const Text(
                            "Reset Your Password",
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Enter your email address. We'll send you a link to reset your password.",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 30),

                          // Email field
                          SlideFadeTransition(
                            delay: 300,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  hintText: "Email Address",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // EmailJS Send Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GestureDetector(
                              onTap: _sendEmailJS,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.orange, Colors.deepOrange],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orangeAccent,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "Send Link",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Footer
                          const Center(
                            child: Text(
                              "© 2025 VeggieFresh",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
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
}

// ------------------------------
// HELPER CLASSES BELOW
// ------------------------------
class AnimatedShape {
  final double size;
  final Color color;
  final double speed;
  final double rotationSpeed;
  final int direction;
  final double position;

  AnimatedShape({
    required this.size,
    required this.color,
    required this.speed,
    required this.rotationSpeed,
    required this.direction,
    required this.position,
  });
}

class SlideFadeTransition extends StatefulWidget {
  final Widget child;
  final int delay;

  SlideFadeTransition({required this.child, this.delay = 0});

  @override
  _SlideFadeTransitionState createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: widget.child,
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.75);

    final cp1 = Offset(size.width * 0.25, size.height * 1.2);
    final cp2 = Offset(size.width * 0.75, size.height * 0.3);
    final end = Offset(size.width, size.height * 0.6);

    path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => oldDelegate.color != color;
}
