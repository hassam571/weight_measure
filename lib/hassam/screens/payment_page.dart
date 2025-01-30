import 'package:flutter/material.dart';
import 'dart:math';

// HELPER CLASSES, same as your other pages:
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

// A simple combination of slide + fade animations, used to reveal widgets nicely.
class SlideFadeTransition extends StatefulWidget {
  final Widget child;
  final int delay; // in milliseconds

  SlideFadeTransition({
    required this.child,
    this.delay = 0,
  });

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

    // Start the animation after [widget.delay] milliseconds
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

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
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

  // Some internal states for Payment
  bool _agreeToTerms = false;
  bool _isCashSelected = false;
  bool _isCreditCardSelected = true;
  bool _isOtherSelected = false;

  // Text Controllers for new card details
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 1) Animated Gradient Controller
    _gradientController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    // The two color tweens for a nice shifting green gradient
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

    // Create some random shapes for a lively background
    for (int i = 0; i < 5; i++) {
      _shapes.add(AnimatedShape(
        size: Random().nextDouble() * 40 + 20,
        color: Colors.white.withOpacity(0.1 + Random().nextDouble() * 0.2),
        speed: Random().nextDouble() * 40 + 20,
        direction: Random().nextBool() ? 1 : -1,
        position: Random().nextDouble(),
      ));
    }

    // 3) Fade Controller for overall page content
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
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  // Toggles between Cash, Credit Card, and Other
  void _selectPaymentMethod(String method) {
    setState(() {
      _isCashSelected = (method == 'Cash');
      _isCreditCardSelected = (method == 'Credit');
      _isOtherSelected = (method == 'Other');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use an AnimatedBuilder for the gradient
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
                          // AppBar-like row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Text(
                                'Check Out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 48), // for alignment
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Step Indicator
                          Text(
                            'STEP 2',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Payment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Payment Method - SlideFadeTransition for a nice reveal
                          SlideFadeTransition(
                            delay: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Choose a payment method',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildPaymentMethodOption(
                                      label: 'Cash',
                                      icon: Icons.money,
                                      isSelected: _isCashSelected,
                                      onTap: () => _selectPaymentMethod('Cash'),
                                    ),
                                    const SizedBox(width: 10),
                                    _buildPaymentMethodOption(
                                      label: 'Credit Card',
                                      icon: Icons.credit_card,
                                      isSelected: _isCreditCardSelected,
                                      onTap: () => _selectPaymentMethod('Credit'),
                                    ),
                                    const SizedBox(width: 10),
                                    _buildPaymentMethodOption(
                                      label: 'Other',
                                      icon: Icons.more_horiz,
                                      isSelected: _isOtherSelected,
                                      onTap: () => _selectPaymentMethod('Other'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Only show Card Details if user selects 'Credit Card'
                          if (_isCreditCardSelected) ...[
                            SlideFadeTransition(
                              delay: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Enter your card details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        _buildTextField(
                                          controller: _cardNumberController,
                                          hint: 'Card Number',
                                          icon: Icons.credit_card,
                                        ),
                                        const SizedBox(height: 12),
                                        _buildTextField(
                                          controller: _expiryDateController,
                                          hint: 'Expiry Date (MM/YY)',
                                          icon: Icons.calendar_today,
                                        ),
                                        const SizedBox(height: 12),
                                        _buildTextField(
                                          controller: _cvcController,
                                          hint: 'CVC',
                                          icon: Icons.lock,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // or check out with...
                          SlideFadeTransition(
                            delay: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'or check out with',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildPaymentIcon('assets/images/pay.png'),
                                    _buildPaymentIcon('assets/images/visa.png'),
                                    _buildPaymentIcon('assets/images/masterc.png'),
                                    _buildPaymentIcon('assets/images/amex.png'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Price Summary
                          SlideFadeTransition(
                            delay: 400,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPriceRow('Product price', '\$110'),
                                const SizedBox(height: 10),
                                _buildPriceRow('Shipping', 'Free ship'),
                                const Divider(
                                    color: Colors.white70, thickness: 0.3),
                                _buildPriceRow('Subtotal', '\$110', isBold: true),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Terms & Conditions
                          SlideFadeTransition(
                            delay: 500,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreeToTerms = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.orange,
                                  checkColor: Colors.white,
                                ),
                                const Text(
                                  'I agree to Terms and conditions',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Place Order Button
                          SlideFadeTransition(
                            delay: 600,
                            child: ElevatedButton(
                              onPressed: _agreeToTerms
                                  ? () {
                                      // Handle place order logic
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                disabledBackgroundColor:
                                    Colors.orange.withOpacity(0.5),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Place my order',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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

  // Generic text field builder for card details
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fully white inside the card details box
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }

  // Payment Method Widget
  Widget _buildPaymentMethodOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white70,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Payment Icon Widget
  Widget _buildPaymentIcon(String imagePath) {
    return Container(
      height: 40,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }

  // Price Row Widget
  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isBold ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
