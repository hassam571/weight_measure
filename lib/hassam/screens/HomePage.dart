import 'package:flutter/material.dart';
import 'ProductPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrganicHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(),
            SizedBox(height: 60),
            ProductCategoriesSection(),
            SizedBox(height: 60),
            ProductsSection(),
            SizedBox(height: 60),
            ReviewsSection(),
            SizedBox(height: 60),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      color: Color(0xFFFFF0E0),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: -100,
            child: Image.asset(
              'assets/proj4/product-1.jpg', // Corrected path and extension
              fit: BoxFit.contain,
              height: 250,
              width: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Eat clean &",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "-- green &.",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "-- Organic",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "What takes us hours to make is yours to enjoy in minutes.",
                  style: TextStyle(
                      fontSize: 16,
                      color:
                          Colors.black), // Increased font size for readability
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    "Shop Product",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCategoriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'image': 'assets/proj4/carrot.png',
      'title': 'Carrots 1KG',
      'price': 2.45
    },
    {
      'image': 'assets/proj4/kale.png',
      'title': 'Onion Brown New Zealand 1KG',
      'price': 1.99
    },
    {'image': 'assets/proj4/product (2).png', 'title': 'Peas 1KG', 'price': 0.99},
    {
      'image': 'assets/proj4/page2-2.jpg',
      'title': 'Lettuce 1KG',
      'price': 1.99
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "OUR PRODUCT CATEGORIES",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Learn ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 16),
              for (var product in products)
                ProductCategoryCard(
                  image: product['image'],
                  title: product['title'],
                  price: product['price'],
                  backgroundColor: Color(0xFFFFF3E0),
                ),
              SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductCategoryCard extends StatelessWidget {
  final String image;
  final String title;
  final double price;
  final Color backgroundColor;

  const ProductCategoryCard({
    required this.image,
    required this.title,
    required this.price,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to ProductPage and pass product details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                imageUrl: image,
                name: title,
                price: price,
              ),
            ),
          );
        },
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  image,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
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
}

// Example ProductDetailsScreen
class ProductDetailsScreen extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const ProductDetailsScreen({
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 200, fit: BoxFit.contain),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Section with Image
          Expanded(
            flex: 1,
            child: Container(
              height: 300, // Fixed height for both sections
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/proj4/veggies.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),

          // Second Section with Text, Grid of Images, and Button
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                Text(
                  "Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Grid of Images
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 images per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: 9, // Adjust as needed
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/proj4/product (${index + 1}).png', // Corrected path and extension
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),

                // Centered View All Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Fully rounded
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Text
          Text(
            "What Our Customers Say",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "We value your feedback and strive to provide the best service.",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          Text(
            "See what others are saying about us.",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),

          // Horizontal Scrollable Row of Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    width: 250, // Fixed width for each card
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Gray background
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Person ${index + 1}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                );
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        // Review Text
                        Text(
                          "This is an amazing service! I absolutely love the quality and the timely delivery.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      width: double.infinity,
      height: 216,
      color: const Color.fromARGB(
          255, 253, 43, 28), // Red background for the container
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 200,
                    width: 300,
                    child: Column(
                      children: [
                        Text(
                          "Our Story",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "We believe in fresh, organic, and healthy produce for everyone.",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors
                                  .white), // Increased font size for readability
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: -60,
            child: Image.asset(
              'assets/proj4/food.png', // Ensure the path and extension are correct
              width: 200, // Adjust the size as needed
              height: 200, // Adjust the size as needed
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String image;
  final String title;

  const CategoryCard({
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;

  const ProductCard({
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(price,
                style: TextStyle(fontSize: 14, color: Colors.green)),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String image;
  final String title;
  final String price;

  Product({required this.image, required this.title, required this.price});

  // Method to convert Firestore document into a Product object
  factory Product.fromFirestore(Map<String, dynamic> firestore) {
    return Product(
      image: firestore['image'] ?? 'assets/proj4/default-image.jpg',
      title: firestore['title'] ?? 'Unknown Product',
      price: firestore['price']?.toString() ?? '0.00',
    );
  }
}
