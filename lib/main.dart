import 'package:flutter/material.dart';
import 'landing_screen.dart';
import 'qr_scanner_screen.dart';
import 'profile_screen.dart';
import 'package:provider/provider.dart';
import 'profile_model.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';
import 'edit_profile.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProfileModel(),
      child: const DriverApp(),
    ),
  );
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrikeGO',
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/reset': (_) => const ResetPasswordScreen(),
        '/main': (_) => const MainPage(),
        '/editProfile': (_) => const EditProfileScreen(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    LandingScreen(),
    QrScannerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      /// Floating QR Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QrScannerScreen(),
            ),
          );
        },
        child: const Icon(Icons.qr_code, color: Colors.black, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// Bottom Navigation
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  /// Custom Bottom Navigation Bar
  Widget _buildBottomNavigation() {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// Map
          InkWell(
            onTap: () => setState(() => _currentIndex = 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map,
                  color: _currentIndex == 0 ? Colors.blue : Colors.black54,
                ),
                const SizedBox(height: 2),
                Text(
                  "MAP",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                    _currentIndex == 0 ? Colors.blue : Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          /// Scan QR Text (center under FAB)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(height: 28), // Push text down under QR button
              Text(
                "SCAN QR TO ENTER\nQUEUE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          /// Profile
          InkWell(
            onTap: () => setState(() => _currentIndex = 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: _currentIndex == 2 ? Colors.blue : Colors.black54,
                ),
                const SizedBox(height: 2),
                Text(
                  "PROFILE",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                    _currentIndex == 2 ? Colors.blue : Colors.black54,
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




