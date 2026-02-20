import 'package:flutter/material.dart';
import '../screens/Adoption/Adoption_Data.dart';
import '../screens/notifications_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  Widget build(BuildContext context) {

    int notificationCount = AdoptionData.notifications.length;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFF6B6B),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('My Posts'),
            onTap: () {},
          ),

          const Divider(),

          // 🔔 Notifications Tile
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),

            trailing: notificationCount > 0
                ? CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Text(
                      notificationCount.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12),
                    ),
                  )
                : null,

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationPage(),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          ),
          ListTile(
              leading: Text('⚙️', style: TextStyle(fontSize: 20)),
              title: Text('Settings'),
              onTap: () {},
            ),

        ],
      ),
    );
  }
}