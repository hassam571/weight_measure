import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_flutter_app/hassam/screens/HomePage.dart';
import 'package:my_flutter_app/hassam/screens/LoginPage.dart';
import 'screens/SplashScreen.dart';
import 'screens/forget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase only once
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBssUhK9RU-0FDYgzm-YAm6dpzx63HcGMc",
        appId: "1:542503334698:android:c65e698e44fd9d7f426453",
        messagingSenderId: "542503334698",
        projectId: "hassam-74f73",
      ),
    );

    // Check if it's the first run of the app
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      // Add products to Firestore
      // await addProductsToFirestore();

      // Set the flag so products are not added again in future runs
      await prefs.setBool('isFirstRun', false);
    }

    runApp(MyApp());
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

Future<void> addProductsToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Check if products are already added
  QuerySnapshot snapshot = await firestore.collection('Farm_Products').get();
  if (snapshot.docs.isNotEmpty) {
    print('Products already exist.');
    return;
  }

  List<Map<String, dynamic>> products = [
    {'image': 'assets/proj4/carrot.png', 'title': 'Carrots 1KG', 'price': 2.45},
    {
      'image': 'assets/proj4/kale.png',
      'title': 'Onion brown new zealand 1KG',
      'price': 1.99
    },
    {'image': 'assets/proj4/peas.png', 'title': 'Kale 1KG', 'price': 0.99},
    {'image': 'assets/proj4/lettuce.png', 'title': 'Peas 1KG', 'price': 1.99},
  ];

  for (var product in products) {
    await firestore.collection('Farm_Products').add(product);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      // home: OrganicHomePage(), // Set the SplashScreen as the home screen
      home: SplashScreen(), // Set the SplashScreen as the home screen
    );
  }
}