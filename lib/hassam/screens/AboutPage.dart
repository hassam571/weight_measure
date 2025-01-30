
import 'package:flutter/material.dart';


class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Stack(
              children: [
                Container(
                  height: 350,
                  color: Color(0xFF2A5545),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Furni.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Home',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  'About Us',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  'Contact',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          'Modern Interior\nDesign Studio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text('Shop Now'),
                            ),
                            SizedBox(width: 16),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text('Explore'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 16,
                  child: Image.asset(
                    'assets/sofa.png',
                    height: 150,
                   
                  ),
                ),
              ],
            ),
            // Crafted Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crafted with excellent material.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Our furniture combines durability and elegance, designed to match your unique style.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProductCard(
                        name: 'Nordic Chair',
                        price: '\$250.00',
                        imagePath: 'assets/nordic_chair.png',
                      ),
                      ProductCard(
                        name: 'Velvet Arm Chair',
                        price: '\$170.00',
                        imagePath: 'assets/velvet_chair.png',
                      ),
                      ProductCard(
                        name: 'Ergonomic Chair',
                        price: '\$430.00',
                        imagePath: 'assets/ergonomic_chair.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Why Choose Us Section
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why Choose Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.local_shipping, size: 40, color: Colors.green),
                            SizedBox(height: 8),
                            Text('Free Shipping'),
                            Text('On all orders over \$50'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.thumb_up, size: 40, color: Colors.green),
                            SizedBox(height: 8),
                            Text('High Quality'),
                            Text('Made from premium materials'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.no_accounts_rounded, size: 40, color: Colors.green),
                            SizedBox(height: 8),
                            Text('Easy Returns'),
                            Text('30-day return policy'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;

  ProductCard({required this.name, required this.price, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(price),
      ],
    );
  }
}
