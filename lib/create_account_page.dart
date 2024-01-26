import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _errorMessage = '';

  // Function to check if the email is valid
  bool _isEmailValid(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  // Function to check if the password is valid
  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  // Function to check if the passwords match
  bool _doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  void _handleCreateAccount() async {
    // Check if the email is valid
    if (!_isEmailValid(_emailController.text)) {
      setState(() {
        _errorMessage = 'Invalid email address.';
      });
      return;
    }

    // Check if the password is valid
    if (!_isPasswordValid(_passwordController.text)) {
      setState(() {
        _errorMessage = 'Invalid password. Password must be at least 6 characters.';
      });
      return;
    }

    // Check if the passwords match
    if (!_doPasswordsMatch(_passwordController.text, _confirmPasswordController.text)) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    try {
      // Use FirebaseAuth to create a new user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // After successful account creation, you can navigate to another screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error creating account: $e');

      // Extract the error message from the exception
      String errorMessage = 'Error creating account';

      if (e is FirebaseAuthException) {
        // Check if the exception is of type FirebaseAuthException
        // and get the human-readable error message from it
        errorMessage = '${e.message}';
      }

      // Handle errors appropriately (show error message, etc.)
      setState(() {
        // Set an error message that can be displayed in a Text widget
        _errorMessage = errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleCreateAccount,
              child: const Text(
                'Create Account',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Set maximum lines
                overflow: TextOverflow.ellipsis, // Display ellipsis (...) if the text exceeds the maximum lines
              ),
            ),
          ],
        ),
      ),
    );
  }
}
