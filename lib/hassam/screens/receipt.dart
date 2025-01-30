import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Soft gray background
      appBar: AppBar(
        backgroundColor: Colors.blue[800], // Vibrant blue for AppBar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text('Order #1514', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Delivery Status Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, // White card for contrast
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_shipping, color: Colors.teal, size: 60), // Teal icon
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your order is delivered',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Rate product to get 5 points for collect.',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Order Details Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255), // Light gray card background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow('Order number', '#1514'),
                    SizedBox(height: 10),
                    _buildRow(
                        'Tracking Number', 'IK987362341', isHighlight: true),
                    SizedBox(height: 10),
                    _buildRow('Delivery address', 'SBI Building, Software Park',
                        isMultiLine: true),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Product and Pricing Summary Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildRow('Maxi Dress', 'x1    \$68.00'),
                    SizedBox(height: 10),
                    _buildRow('Linen Dress', 'x1    \$52.00'),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey[300]),
                    _buildRow('Sub Total', '\$120.00', isSubtle: true),
                    SizedBox(height: 10),
                    _buildRow('Shipping', '\$0.00', isSubtle: true),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey[300]),
                    _buildRow(
                      'Total',
                      '\$120.00',
                      isBold: true,
                      textStyleSize: 16,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: BorderSide(color: Colors.blue),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                      ),
                      onPressed: () {},
                      child: Text('Return home',
                          style: TextStyle(color: Colors.blue)),
                    ),
                    SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                      ),
                      onPressed: () {},
                      child: Text('Rate', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value,
      {bool isBold = false,
      bool isSubtle = false,
      bool isMultiLine = false,
      bool isHighlight = false,
      double textStyleSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isSubtle ? Colors.grey[600] : Colors.black,
            fontSize: textStyleSize,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isHighlight
                  ? Colors.blue[700]
                  : (isSubtle ? Colors.grey[600] : Colors.black),
              fontSize: textStyleSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
