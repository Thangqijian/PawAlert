import 'package:flutter/material.dart';
import 'screens/donation_screen.dart';
import 'screens/Adoption/Adoption_HomePage.dart';
import 'widgets/app_drawer.dart';

void main() {
  runApp(PawGuardApp());
}

class PawGuardApp extends StatelessWidget {
  const PawGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawGuard',
      theme: ThemeData(
        primaryColor: Color(0xFFFF6B6B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFF6B6B),
          primary: Color(0xFFFF6B6B),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    SimpleHomeContent(),
    DonationScreen(),
    AdoptionScreen(),
    PlaceholderScreen(title: 'Lost & Found'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFFF6B6B),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: [
          BottomNavigationBarItem(
            icon: Text('🚨', style: TextStyle(fontSize: 24)),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Text('💰', style: TextStyle(fontSize: 24)),
            label: 'Donation',
          ),
          BottomNavigationBarItem(
            icon: Text('🏠', style: TextStyle(fontSize: 24)),
            label: 'Adoption',
          ),
          BottomNavigationBarItem(
            icon: Text('🔍', style: TextStyle(fontSize: 24)),
            label: 'Lost/Found',
          ),
        ],
      ),
    );
  }
}

class SimpleHomeContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF6B6B),
        title: Row(
          children: [
            Text('🐾 ', style: TextStyle(fontSize: 24)),
            Text('PawGuard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🚨', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text(
              'Emergency Feature',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text('(Coming Soon)', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 40),
            Text(
              '👇 Click Donation Below 👇',
              style: TextStyle(fontSize: 16, color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold),
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
        backgroundColor: Color(0xFFFF6B6B),
        title: Text(title, style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🚧', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text(
              '$title Feature',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text('(Coming Soon)', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}