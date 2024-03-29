import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _firstName = '';
  String _lastName = '';
  String _phoneNumber = '';
  String defaultProfilePictureURL = 'https://cdn2.vectorstock.com/i/1000x1000/20/76/man-avatar-profile-vector-21372076.jpg';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.email).get();

      if (userDoc.exists) {
        setState(() {
          _firstName = userDoc['firstName'] ?? '';
          _lastName = userDoc['lastName'] ?? '';
          _phoneNumber = userDoc['phoneNumber'] ?? '';
        });
      }
    }
  }

  String get _displayName {
    if (_firstName.isNotEmpty || _lastName.isNotEmpty) {
      return '$_firstName $_lastName';
    } else {
      return 'Guest';
    }
  }

  String get _displayPhoneNumber {
    if (_phoneNumber.isNotEmpty) {
      return _phoneNumber;
    } else {
      return 'Please add your phone number';
    }
  }

  String _profilePictureUrl = 'https://cdn2.vectorstock.com/i/1000x1000/20/76/man-avatar-profile-vector-21372076.jpg';

  void _handleLogout() async {
    await _deleteCredentials();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
  }

  Future<void> _handleChangeProfilePicture() async {
    final newProfilePictureUrl = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? url;
        return AlertDialog(
          title: const Text('Change Profile Picture'),
          content: TextField(
            onChanged: (value) {
              url = value;
            },
            decoration: const InputDecoration(labelText: 'New Profile Picture URL'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(url); // Confirm
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (newProfilePictureUrl != null) {
      try {
        final response = await http.head(Uri.parse(newProfilePictureUrl));

        if (response.statusCode == 200) {
          setState(() {
            _profilePictureUrl = newProfilePictureUrl;
          });
        } else {
          // Display a toast message for invalid image URL
          Toast.show("Invalid image URL", duration: Toast.lengthShort, gravity: Toast.bottom);
        }
      } catch (e) {
        // Handle errors and display a toast message
        Toast.show("Error: $e", duration: Toast.lengthShort, gravity: Toast.bottom);
      }
    }
  }

  void _handleChangePhoneNumber() async {
    final newPhoneNumber = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? phoneNumber;
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Change Phone Number'),
            content: TextField(
              onChanged: (value) {
                phoneNumber = value;
              },
              decoration: const InputDecoration(labelText: 'New Phone Number'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null); // Cancel
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(phoneNumber); // Confirm
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );

    if (newPhoneNumber != null) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update user details in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.email).update({
          'phoneNumber': newPhoneNumber,
        });

        setState(() {
          _phoneNumber = newPhoneNumber;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100.0,
                  backgroundImage: NetworkImage(_profilePictureUrl),
                ),
                const SizedBox(height: 16.0),
                Text(
                  _displayName,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Text(
                  _displayPhoneNumber,
                  style: _phoneNumber.isNotEmpty
                      ? const TextStyle(fontSize: 16.0)
                      : const TextStyle(fontSize: 16.0, color: Colors.red),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _handleChangeProfilePicture,
                  child: const Text('Change Profile Picture'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _handleChangePhoneNumber,
                  child: const Text('Change Phone Number'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _handleLogout,
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
