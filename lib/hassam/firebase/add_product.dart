import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(String name, String price) async {
    try {
      await _firestore.collection('products').add({
        'name': name,
        'price': price,
      });
      print("Product added successfully!");
    } catch (e) {
      print("Error adding product: $e");
    }
  }
}
