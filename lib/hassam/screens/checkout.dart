import 'package:flutter/material.dart';
import 'dart:math';

import 'shipping_address.dart';

/// Represents each floating shape in the background, with rotation.
class AnimatedShape {
  final double size;
  final Color color;
  final double speed;
  final double rotationSpeed; // how fast it rotates
  final int direction; // 1 => right, -1 => left
  final double position; // horizontal start position (0..1)

  AnimatedShape({
    required this.size,
    required this.color,
    required this.speed,
    required this.rotationSpeed,
    required this.direction,
    required this.position,
  });
}

/// Slide + fade animations with optional delay
class SlideFadeTransition extends StatefulWidget {
  final Widget child;
  final int delay; // milliseconds

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
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation after [widget.delay]
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

/// A custom painter for a wave at the top of the screen
class WavePainter extends CustomPainter {
  final Color color;
  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    path.lineTo(0, 0);
    // Move down
    path.lineTo(0, size.height * 0.75);

    // Create wave with cubic bezier
    final controlPoint1 = Offset(size.width * 0.25, size.height * 1.2);
    final controlPoint2 = Offset(size.width * 0.75, size.height * 0.3);
    final endPoint = Offset(size.width, size.height * 0.6);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy, endPoint.dx, endPoint.dy);

    // Then to top-right
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => oldDelegate.color != color;
}

/// The enhanced CheckoutPage
class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with TickerProviderStateMixin {
  // Sample cart items
  List<Map<String, dynamic>> cartItems = [
    {
      'image': 'assets/proj4/carrot.png',
      'name': 'Jeruk',
      'price': 'RP 12.000',
    },
    {
      'image': 'assets/proj4/carrot.png',
      'name': 'Alpukat',
      'price': 'RP 23.000',
    },
    {
      'image': 'assets/proj4/carrot.png',
      'name': 'Wortel',
      'price': 'RP 17.000',
    },
    {
      'image': 'assets/proj4/carrot.png',
      'name': 'Bawang Bombay',
      'price': 'RP 15.000',
    },
    {
      'image': 'assets/proj4/carrot.png',
      'name': 'Kol',
      'price': 'RP 20.000',
    },
  ];

  // Animation Controllers
  late AnimationController _gradientController;
  late AnimationController _shapeController;
  late AnimationController _fadeController;

  // Button press animation
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  // Gradient Animations
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  // Floating Shapes
  final List<AnimatedShape> _shapes = [];

  // Fade Animation for page
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

    // 2) Floating Shapes
    _shapeController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Generate shapes with rotation
    for (int i = 0; i < 6; i++) {
      _shapes.add(
        AnimatedShape(
          size: Random().nextDouble() * 40 + 20,
          color: Colors.white.withOpacity(0.1 + Random().nextDouble() * 0.2),
          speed: Random().nextDouble() * 40 + 20,
          rotationSpeed: Random().nextDouble() * 2 + 0.5, // rotate speed
          direction: Random().nextBool() ? 1 : -1,
          position: Random().nextDouble(),
        ),
      );
    }

    // 3) Fade for main content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // 4) Button press animation
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.04, // slight scale
    );
    _buttonScaleAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticInOut,
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _shapeController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  // Animate button press with scale effect
  void _onButtonTapDown(TapDownDetails details) {
    _buttonController.forward();
  }

  void _onButtonTapUp(TapUpDetails details) {
    _buttonController.reverse();
  }

  void _onButtonTapCancel() {
    _buttonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Animated gradient + wave
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final color1 = _colorAnimation1.value ?? Colors.green.shade400;
          final color2 = _colorAnimation2.value ?? Colors.green.shade700;

          return Container(
            color: color1,
            child: Stack(
              children: [
                // Top wave
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 180),
                  painter: WavePainter(color: color2),
                ),

                // Floating Animated Shapes
                ..._shapes.map((shape) {
                  return AnimatedBuilder(
                    animation: _shapeController,
                    builder: (context, child) {
                      final time = _shapeController.value * 2 * pi;
                      // horizontal offset
                      final offset = (sin(time) * 20 / shape.speed) * shape.direction;
                      // rotation offset
                      final rotation = time * shape.rotationSpeed;

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

                // Main content with fade-in
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // "AppBar"
                  Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Back Arrow Button
      IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      const Text(
        "Checkout",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Spacer for alignment (keeps text centered)
      const SizedBox(width: 48),
    ],
  ),
),


                        // Cart List
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return SlideFadeTransition(
                                delay: 120 * (index + 1),
                                child: _buildCartItem(item, index),
                              );
                            },
                          ),
                        ),

                        // Checkout button with scale-on-press
                        GestureDetector(
                          onTapDown: _onButtonTapDown,
                          onTapUp: _onButtonTapUp,
                          onTapCancel: _onButtonTapCancel,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShippingAddressPage(),
                              ),
                            );
                          },
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 1.0, end: 0.96)
                                .animate(_buttonScaleAnimation),
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(16),
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Check Out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
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

  /// Builds a single cart item with a gradient background & new terminology
  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.green.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item['image'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),

          // Name & "Farm-Fresh Price"
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Farm-Fresh Price: ${item['price']}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  "100% Organic",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // In Basket checkbox + remove button
          Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (bool? value) {
                      // In a real app, handle toggle
                    },
                  ),
                  const Text(
                    "In Basket",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    cartItems.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
