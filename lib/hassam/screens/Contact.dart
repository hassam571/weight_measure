import 'package:flutter/material.dart';



class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First section with the text section and form side by side
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Section (Right side)
                  Expanded(child: TextSection()),

                  SizedBox(width: 16), // Space between form and text section

                  // Form Section (Left side)
                  Expanded(child: FormSection()),
                ],
              ),

               SizedBox(height: 70),
               CustomTextAndCardsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
class TextSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CallToAction(title: "Call To Action", fontSize: 32),
          SizedBox(height: 8),
          CallToAction(title: "Message", message: "1-814-219-983.", fontSize: 16),
          SizedBox(height: 16),
          CallToAction(title: "Address", message: "Send us a text below the number", fontSize: 16),
          SizedBox(height: 16),
         // No message provided
         
          IconRow(),
        ],
      ),
    );
  }
}

class CallToAction extends StatelessWidget {
  final String title;
  final String? message; // Nullable message
  final double fontSize;

  const CallToAction({
    Key? key,
    required this.title,
    this.message, // Message is optional
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (message != null) // Only display message if it's not null
            Text(message!, style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

class IconRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, size: 16),
        SizedBox(width: 8),  // Adds space between the icons
        Icon(Icons.favorite, size: 16),
        SizedBox(width: 8),  // Adds space between the icons
        Icon(Icons.home, size: 16),
        SizedBox(width: 8),  // Adds space between the icons
        Icon(Icons.settings, size: 16),
      ],
    );
  }
}

class FormSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 80),
          Text("Let's work together", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Adjusted font size
          SizedBox(height: 10),
          CustomTextField(labelText: "Enter your name"),
          SizedBox(height: 16),
          CustomTextField(labelText: "Enter your email"),
          SizedBox(height: 16),
          
          // Message Input (4 rows)
         
          MessageInputField(),
          SizedBox(height: 16),

          SubmitButton(),
        ],
      ),
    );
  }
}

class MessageInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 4,  // This ensures the TextField has 4 rows
      decoration: InputDecoration(
        labelText: "Enter your message",
        border: OutlineInputBorder(),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;

  const CustomTextField({Key? key, required this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      onPressed: () {
        // Handle form submission
      },
      child: Text(
        "Submit",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }


}















class CustomTextAndCardsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Text
        Text(
          "Articles",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        // Second Text
        Text(
          "The plant e-commerce industry has blossomed in recent years.",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(height: 16),

        // Row of 3 cards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomCard(imageAsset: 'assets/proj4/veggies.jpg', title: "Vegetation"),
            CustomCard(imageAsset: 'assets/proj4/page2-3.jpg', title: "Growth"),
            CustomCard(imageAsset: 'assets/proj4/page2-2.jpg', title: "Healthy & Fresh"),
          ],
        ),
      ],
    );
  }
}









class CustomCard extends StatelessWidget {
  final String imageAsset;
  final String title;

  const CustomCard({
    Key? key,
    required this.imageAsset,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        // Set a fixed size for the card
        width: 140,  // You can adjust the width based on your layout needs
        height: 200, // You can adjust the height as well
        child: Stack(
          children: [
            // Image background with opacity overlay
            Positioned.fill(
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.8),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            // Text on top of image
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
