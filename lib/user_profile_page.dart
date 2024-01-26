import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _displayName = 'John Doe'; // Set the initial display name
  String _profilePictureUrl =
      'https://example.com/default_profile_picture.jpg'; // Set the initial profile picture URL

  // Function to handle the logout button
  void _handleLogout() {
    // Implement your logout logic here
    // For example, you can navigate to the login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Function to handle changing the profile picture
  void _handleChangeProfilePicture() {
    // Implement your logic to change the profile picture
    // This can involve opening a dialog, selecting an image, and updating the _profilePictureUrl
    // For simplicity, let's assume the new profile picture URL is set in this function
    setState(() {
      _profilePictureUrl = 'https://example.com/new_profile_picture.jpg';
    });
  }

  // Function to handle changing the display name
  void _handleChangeDisplayName() {
    // Implement your logic to change the display name
    // This can involve opening a dialog, taking user input, and updating the _displayName
    // For simplicity, let's assume the new display name is set in this function
    setState(() {
      _displayName = 'New Display Name';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(_profilePictureUrl),
            ),
            const SizedBox(height: 16.0),
            Text(
              _displayName,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleChangeProfilePicture,
              child: const Text('Change Profile Picture'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleChangeDisplayName,
              child: const Text('Change Display Name'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleLogout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
