import 'package:flutter/material.dart';
import 'checkout.dart';

class ProductPage extends StatelessWidget {
  final String name;
  final double price; // e.g. price per kilo or per piece
  final String imageUrl;

  const ProductPage({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A standard AppBar to match your other pages
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Product Details"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with overlay
            ProductImageWithOverlay(imageUrl: imageUrl),

            // Product Information section
            ProductInfo(
              productName: name,
              piecePrice: price,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImageWithOverlay extends StatelessWidget {
  final String imageUrl;

  const ProductImageWithOverlay({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Image
        Container(
          margin: const EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Image.network(
            imageUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class ProductInfo extends StatefulWidget {
  final String productName;
  final double piecePrice; // e.g. price if buying by piece

  const ProductInfo({
    required this.productName,
    required this.piecePrice,
  });

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  // Mode: false => Buy a Kilo, true => Buy by Piece (Price-based)
  bool isBuyByPiece = false;

  // For "Buy a Kilo" mode:
  // user enters # of kilos, then total price = kiloQty * piecePrice
  final TextEditingController _kiloController = TextEditingController(text: "1");

  // For "Buy by Piece (price-based)" mode:
  // user enters total money, then pieceQty = totalMoney / piecePrice
  final TextEditingController _moneyController =
      TextEditingController(text: "100");

  double totalPrice = 0.0;
  double quantity = 0.0; // can be # of kilos or # of pieces

  @override
  void initState() {
    super.initState();
    // Default: if isBuyByPiece = false => "Buy a Kilo"
    _calculateKilo(); // default
  }

  void _calculateKilo() {
    // For "Buy a Kilo" mode
    // If user typed 2 => quantity = 2 kilos
    // totalPrice = quantity * piecePrice
    final kiloValue = double.tryParse(_kiloController.text) ?? 1.0;
    quantity = kiloValue < 0 ? 1.0 : kiloValue; // clamp min=1
    totalPrice = quantity * widget.piecePrice;
    setState(() {});
  }

  void _calculatePiece() {
    // For "Buy by Piece (price-based)" mode
    // user enters total money => totalPrice = userMoney
    // quantity = totalPrice / piecePrice
    final moneyValue = double.tryParse(_moneyController.text) ?? 0.0;
    totalPrice = moneyValue < 0 ? 0.0 : moneyValue;
    if (widget.piecePrice > 0) {
      quantity = totalPrice / widget.piecePrice;
    } else {
      quantity = 0;
    }
    setState(() {});
  }

  void _toggleMode(bool buyByPiece) {
    setState(() {
      isBuyByPiece = buyByPiece;
      if (isBuyByPiece) {
        _calculatePiece();
      } else {
        _calculateKilo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Give enough height to fit all content
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            widget.productName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Show total price
          Text(
            "₱${totalPrice.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, color: Colors.green),
          ),
          const SizedBox(height: 8),

          const Text(
            "For reference only: An image of a fresh cabbage",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Toggle Buttons: "Buy a Kilo" vs. "Buy a Piece"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _toggleMode(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isBuyByPiece ? Colors.green : Colors.white,
                  foregroundColor: !isBuyByPiece ? Colors.white : Colors.green,
                  side: const BorderSide(color: Colors.green),
                ),
                child: const Text("Buy a Kilo"),
              ),
              ElevatedButton(
                onPressed: () => _toggleMode(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBuyByPiece ? Colors.green : Colors.white,
                  foregroundColor: isBuyByPiece ? Colors.white : Colors.green,
                  side: const BorderSide(color: Colors.green),
                ),
                child: const Text("Buy by Price"),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // If isBuyByPiece => show a text field for total money
          // else => show a text field for # of kilos
          if (!isBuyByPiece) ...[
            TextFormField(
              controller: _kiloController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Number of Kilos",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _calculateKilo(),
            ),
            const SizedBox(height: 8),
            Text(
              "Total Kilos: ${quantity.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "Total Price: ₱${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ] else ...[
            // "Buy by Piece (Price-based)"
            TextFormField(
              controller: _moneyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter total money (₱)",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _calculatePiece(),
            ),
            const SizedBox(height: 8),
            Text(
              "Pieces: ${quantity.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "You will pay: ₱${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],

          const SizedBox(height: 16),

          // "Add to Cart" Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // e.g. pass quantity & totalPrice to next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Add to Cart",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
