import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Icon
                  Icon(
                    Icons.lock_reset,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  // Title Text
                  Text(
                    "Forgot Your Password?",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  // Subtitle Text
                  Text(
                    "Enter your registered email address below. We'll send you instructions to reset your password.",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  // Email Input Field
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Email Address",
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Reset Button
                  ElevatedButton.icon(
                    onPressed: () {
                      final email = emailController.text.trim();
                      if (email.isNotEmpty) {
                        // Handle password reset logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Password reset link sent to $email")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter your email address.")),
                        );
                      }
                    },
                    icon: Icon(Icons.send_rounded),
                    label: Text("Reset Password"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Back to Login Button
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    label: Text(
                      "Back to Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}