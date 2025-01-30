import 'package:flutter/material.dart';
import 'dart:math';

import 'payment_page.dart'; // Adjust if needed
import 'receipt.dart';      // If you need to reference this elsewhere

// Helper class for floating shapes (same as in other pages)
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

// A reusable slide + fade transition widget
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
      begin: const Offset(0, 0.1), // Slightly below final position
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation after widget.delay
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

class ShippingAddressPage extends StatefulWidget {
  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage>
    with TickerProviderStateMixin {
  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Animation Controllers
  late AnimationController _gradientController;
  late AnimationController _shapeController;
  late AnimationController _fadeController;

  // Gradient Animations
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  // List of floating shapes
  List<AnimatedShape> _shapes = [];

  // Fade animation
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1) Animated Gradient
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

    // 2) Floating Shapes Controller
    _shapeController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Generate random shapes
    for (int i = 0; i < 5; i++) {
      _shapes.add(AnimatedShape(
        size: Random().nextDouble() * 40 + 20,
        color: Colors.white.withOpacity(0.1 + Random().nextDouble() * 0.2),
        speed: Random().nextDouble() * 40 + 20,
        direction: Random().nextBool() ? 1 : -1,
        position: Random().nextDouble(),
      ));
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
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use an AnimatedBuilder for the gradient background
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
                // Floating Animated Shapes in the background
                ..._shapes.map((shape) => Positioned(
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
                    )),
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom "AppBar"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                              ),
                              const Text(
                                "Shipping Address",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Icon + Heading
                          Center(
                            child: SlideFadeTransition(
                              delay: 100,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.local_shipping,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Add Shipping Details",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "We need this info to deliver your order.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // TextFields
                          SlideFadeTransition(
                            delay: 200,
                            child: _buildTextField(
                              controller: nameController,
                              label: "Full Name",
                              icon: Icons.person_outline,
                            ),
                          ),
                          const SizedBox(height: 20),

                          SlideFadeTransition(
                            delay: 300,
                            child: _buildTextField(
                              controller: phoneController,
                              label: "Phone Number",
                              icon: Icons.phone_android,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(height: 20),

                          SlideFadeTransition(
                            delay: 400,
                            child: _buildTextField(
                              controller: addressController,
                              label: "Address",
                              icon: Icons.location_on_outlined,
                              maxLines: 3,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Save Button
                          SlideFadeTransition(
                            delay: 500,
                            child: Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Validate fields
                                  final name = nameController.text.trim();
                                  final phone = phoneController.text.trim();
                                  final address = addressController.text.trim();

                                  if (name.isNotEmpty &&
                                      phone.isNotEmpty &&
                                      address.isNotEmpty) {
                                    // Navigate to PaymentPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentPage(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Please fill in all fields."),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Save Address",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
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

  // Helper TextField builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.green),
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
