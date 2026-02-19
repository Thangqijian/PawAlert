import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/donation_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/Adoption/Adoption_HomePage.dart';
import 'screens/chat_list_screen.dart';
import 'screens/LostnFound/LostnFound_page.dart';
import 'widgets/app_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PawGuardApp());
}

class PawGuardApp extends StatelessWidget {
  const PawGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrayCare',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6B6B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B6B),
          primary: const Color(0xFFFF6B6B),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // FIXED: Added ChatListScreen to match the 5 navigation items
  final List<Widget> _screens = [
    EmergencyScreen(),
    DonationScreen(),
    const AdoptionScreen(),
    const LostHomePage(),
    const ChatListScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      endDrawer: const AppDrawer(),
      
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFF6B6B),
          unselectedItemColor: Colors.grey[400],
          backgroundColor: Colors.white,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Text('🚨', style: TextStyle(fontSize: 22)),
              activeIcon: Text('🚨', style: TextStyle(fontSize: 24)),
              label: 'Emergency',
            ),
            BottomNavigationBarItem(
              icon: Text('💰', style: TextStyle(fontSize: 22)),
              activeIcon: Text('💰', style: TextStyle(fontSize: 24)),
              label: 'Donation',
            ),
            BottomNavigationBarItem(
              icon: Text('🏠', style: TextStyle(fontSize: 22)),
              activeIcon: Text('🏠', style: TextStyle(fontSize: 24)),
              label: 'Adoption',
            ),
            BottomNavigationBarItem(
              icon: Text('🔍', style: TextStyle(fontSize: 22)),
              activeIcon: Text('🔍', style: TextStyle(fontSize: 24)),
              label: 'Lost/Found',
            ),
            BottomNavigationBarItem(
              icon: Text('💬', style: TextStyle(fontSize: 22)),
              activeIcon: Text('💬', style: TextStyle(fontSize: 24)),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🚧', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              '$title Feature',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text('(Coming Soon)', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}