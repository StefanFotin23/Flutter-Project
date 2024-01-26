import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/firebase_options.dart';
import 'home_page.dart';
import 'user_profile_page.dart';
import 'login_page.dart'; // Import your login page file
import 'create_account_page.dart'; // Import your create account page file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unsplash App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/createAccount': (context) => const CreateAccountPage(),
        '/home': (context) => const AppContainer(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final bool _isLoggedIn = false; // Set this based on authentication state

  @override
  void initState() {
    super.initState();
    // Add logic to check authentication status and update _isLoggedIn accordingly
    // For example, you can use Firebase Authentication to check if the user is logged in
    // and update _isLoggedIn.
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? const AppContainer() : const LoginPage();
  }
}

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _currentIndex = 0; // Index of the selected tab
  final List<Widget> _pages = [
    const HomePage(),
    const UserProfilePage(),
    // Add more pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // Add more BottomNavigationBarItems as needed
        ],
      ),
    );
  }
}
