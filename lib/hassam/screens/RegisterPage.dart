import 'package:flutter/material.dart';
import 'dart:math';

import 'HomePage.dart';
import 'LoginPage.dart'; // <-- Make sure to import your LoginPage
import '../firebase/authentication.dart'; // Ensure this points to your AuthService file

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  // Controllers for capturing user input from text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // Animation Controllers
  late AnimationController _gradientController;
  late AnimationController _shapeController;
  late AnimationController _fadeController;

  // Gradient Animation
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  // Shape Positions
  List<AnimatedShape> _shapes = [];

  // Fade-in Animation
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Gradient Animation Controller
    _gradientController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation1 =
        ColorTween(begin: Colors.green.shade400, end: Colors.green.shade700)
            .animate(_gradientController);
    _colorAnimation2 =
        ColorTween(begin: Colors.green.shade700, end: Colors.green.shade400)
            .animate(_gradientController);

    // Shape Animation Controller
    _shapeController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Initialize some shapes
    for (int i = 0; i < 5; i++) {
      _shapes.add(
        AnimatedShape(
          size: Random().nextDouble() * 50 + 20,
          color: Colors.white.withOpacity(0.1 + Random().nextDouble() * 0.2),
          speed: Random().nextDouble() * 50 + 20,
          direction: Random().nextBool() ? 1 : -1,
          position: Random().nextDouble(),
        ),
      );
    }

    // Fade-in Animation Controller
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle user registration
  void _registerUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // If your AuthService's signUp method only accepts (email, password),
    // remove 'name' from the call:
    final user = await _authService.signUp(email, password);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrganicHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration failed. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ..._shapes.map((shape) => Positioned(
                      left: MediaQuery.of(context).size.width *
                          shape.position *
                          shape.direction,
                      top: MediaQuery.of(context).size.height * 0.2,
                      child: AnimatedBuilder(
                        animation: _shapeController,
                        builder: (context, child) {
                          double offset =
                              (sin(_shapeController.value * 2 * pi) *
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
                    )),
                // Main Content with Fade-in
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Icon + Title
                          Center(
                            child: Icon(
                              Icons.local_grocery_store,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "VeggieFresh",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Greeting Text
                          Text(
                            "Hello!",
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Register your account to start selling & buying fresh vegetables.",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 30),

                          // Name Field
                          SlideFadeTransition(
                            delay: 300,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "Name",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email Field
                          SlideFadeTransition(
                            delay: 600,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  hintText: "Email",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          SlideFadeTransition(
                            delay: 900,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: "Password",
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

                          // Register Button
                          ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.orange,
                              elevation: 5,
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Already Have an Account? Log In
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to your Login page
                                  Navigator.pop(context); // or push to LoginPage
                                  // Example:
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => LoginPage()),
                                  // );
                                },
                                child: Text(
                                  "Log In",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Footer
                          Text(
                            "© 2025 VeggieFresh",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
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

// --------------------- //
// HELPER CLASSES BELOW //
// --------------------- //

// Represents each floating shape in the background
class AnimatedShape {
  final double size;
  final Color color;
  final double speed;
  final int direction; // 1 for right, -1 for left
  final double position;

  AnimatedShape({
    required this.size,
    required this.color,
    required this.speed,
    required this.direction,
    required this.position,
  });
}

// Combines slide + fade animations with an optional delay
class SlideFadeTransition extends StatefulWidget {
  final Widget child;
  final int delay; // in milliseconds

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

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation after the delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
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
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: widget.child,
      ),
    );
  }
}
