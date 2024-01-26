import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
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

  // Function to check if the phoneNumber is valid
  bool _isPhoneNumberValid(String phoneNumber) {
    return phoneNumber.length == 10;
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
        _errorMessage =
        'Invalid password. Password must be at least 6 characters.';
      });
      return;
    }

    // Check if the passwords match
    if (!_doPasswordsMatch(
        _passwordController.text, _confirmPasswordController.text)) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    // Check if the phoneNumber is valid
    if (!_isPhoneNumberValid(_phoneNumberController.text)) {
      setState(() {
        _errorMessage = 'Invalid phone number. Must have exactly 10 digits.';
      });
      return;
    }

    try {
      // Use FirebaseAuth to create a new user with email and password
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Access the user data from the UserCredential
      final User user = userCredential.user!;

      // Save additional user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.email).set({
        'email': user.email,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phoneNumber': _phoneNumberController.text,
      });

      // After successful account creation, you can navigate to another screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (e is FirebaseException) {
        // Check if the exception is of type FirebaseAuthException
        // and get the human-readable error message from it
        setState(() {
          // Set an error message that can be displayed in a Text widget
          _errorMessage = '${e.message}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _handleCreateAccount,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
