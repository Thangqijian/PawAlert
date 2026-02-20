import 'package:flutter/material.dart';
import 'Adoption/Adoption_Data.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xFFFF6B6B),
      ),

      body: AdoptionData.notifications.isEmpty
          ? const Center(
              child: Text("No Notifications Yet"),
            )
          : ListView.builder(
              itemCount: AdoptionData.notifications.length,
              itemBuilder: (context, index) {
                final note = AdoptionData.notifications[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(note["title"]),
                    subtitle: Text(note["message"]),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.clear),
        onPressed: () {
          AdoptionData.notifications.clear();
          Navigator.pop(context);
        },
      ),
    );
  }
}