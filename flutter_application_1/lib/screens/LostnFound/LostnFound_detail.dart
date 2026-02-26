import 'package:flutter/material.dart';
import '../LostnFound/LostnFound_data.dart';


class LostDetailPage extends StatelessWidget {
  final Map<String, dynamic> pet;

  const LostDetailPage({super.key, required this.pet});

  bool get _isOwner => pet["ownerId"] == LostAndFoundData.currentUserId;

  @override
  Widget build(BuildContext context) {
    final phone = pet["ownerPhone"] ?? pet["phone"] ?? "Not provided";
    final ownerName = pet["ownerName"] ?? "Unknown";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(pet["name"]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Photo Placeholder
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.pets, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Pet Details
            Text(
              pet["name"],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 20),
                const SizedBox(width: 6),
                Text(pet["location"], style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.green, size: 20),
                const SizedBox(width: 6),
                Text(
                  "Reward: ${pet["reward"]}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              pet["description"],
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 32),

            // ── Owner Information ────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Posted by",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.red.shade100,
                        child: Text(
                          ownerName.isNotEmpty ? ownerName[0].toUpperCase() : "?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ownerName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Contact: $phone",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ── Mark as Found Button ── only for owner ───────────
            if (_isOwner && pet["status"] == "Lost")
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    LostAndFoundData.markAsFound(pet["id"]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("🎉 Marked as Found!")),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "MARK AS FOUND",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}