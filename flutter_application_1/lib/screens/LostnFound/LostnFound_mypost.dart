import 'package:flutter/material.dart';
import '../LostnFound/LostnFound_data.dart';

class LostMyPostsPage extends StatefulWidget {
  const LostMyPostsPage({super.key});

  @override
  State<LostMyPostsPage> createState() => _LostMyPostsPageState();
}

class _LostMyPostsPageState extends State<LostMyPostsPage> {
  List<Map<String, dynamic>> get myPosts => LostAndFoundData.lostPets
      .where((p) => p["ownerId"] == LostAndFoundData.currentUserId)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("📋 My Lost Posts"),
      ),
      body: myPosts.isEmpty
          ? const Center(
              child: Text(
                "You haven't posted any lost pets yet",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myPosts.length,
              itemBuilder: (context, index) {
                final pet = myPosts[index];
                final isLost = pet["status"] == "Lost";

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: isLost ? Colors.red.shade100 : Colors.green.shade100,
                      child: Icon(
                        isLost ? Icons.pets : Icons.check_circle,
                        color: isLost ? Colors.red : Colors.green,
                      ),
                    ),
                    title: Text(
                      pet["name"],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${pet["location"]} • ${pet["reward"]}"),
                        const SizedBox(height: 4),
                        Text(
                          "Status: ${pet["status"]}",
                          style: TextStyle(
                            color: isLost ? Colors.red : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: isLost
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(100, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              LostAndFoundData.markAsFound(pet["id"]);
                              setState(() {}); // refresh list
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Marked as Found")),
                              );
                            },
                            child: const Text(
                              "Found",
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          )
                        : const Icon(Icons.check_circle, color: Colors.green, size: 32),
                  ),
                );
              },
            ),
    );
  }
}