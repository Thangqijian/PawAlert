import 'dart:convert'; // Required for Base64 decoding
import 'package:flutter/material.dart';

class EmergencyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> caseData;

  const EmergencyDetailScreen({super.key, required this.caseData});

  @override
  Widget build(BuildContext context) {
    // 1. Decode the Base64 image for the header
    final Widget imageHeader = (caseData['imageBase64'] != null &&
            caseData['imageBase64'].isNotEmpty)
        ? Image.memory(base64Decode(caseData['imageBase64']), fit: BoxFit.cover)
        : Container(
            color: Colors.grey[300], child: const Icon(Icons.pets, size: 100));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Text('Emergency Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: Real Animal Photo ---
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageHeader,
                  Container(
                      color:
                          Colors.black26), // Dark overlay for text readability
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getUrgencyColor(caseData['status']),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        caseData['status'].toString().toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Location & Time ---
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFFF6B6B)),
                      const SizedBox(width: 8),
                      Text(caseData['location'] ?? 'Unknown Location',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text(caseData['timeAgo'] ?? 'Just now',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Divider(height: 30),

                  const Text('🆘 Help Requested',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: (caseData['helpNeeded'] as List<dynamic>?)
                            ?.map((help) {
                          return Chip(
                            label: Text(
                              help.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            backgroundColor: const Color(0xFFFF6B6B),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          );
                        }).toList() ??
                        [
                          const Text('No specific equipment requested',
                              style: TextStyle(color: Colors.grey))
                        ],
                  ),

                  const SizedBox(height: 25),

                  // --- AI SAFETY TIPS (The "Brain" feature) ---
                  const Text('🛡️ AI Safety Advice',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // This displays the tips Gemini generated in Step 8
                  _buildSafetyTipsSection(caseData['safetyTips']),

                  const SizedBox(height: 25),

                  // --- Description ---
                  const Text('Situation',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(caseData['description'] ?? 'No description provided.',
                      style: const TextStyle(fontSize: 15, height: 1.5)),

                  const SizedBox(height: 40),

                  // --- Action Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _showHelpConfirm(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B)),
                      child: const Text('I AM NEARBY & CAN HELP',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildSafetyTipsSection(dynamic tips) {
    // If we haven't saved tips yet, show a generic one
    final List<dynamic> tipList = tips ??
        [
          "Keep a safe distance from the animal.",
          "Do not offer food unless advised by a vet.",
          "Wait for professional rescuers if it's dangerous."
        ];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[100]!)),
      child: Column(
        children: tipList
            .map((tip) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(
                          child: Text(tip.toString(),
                              style: TextStyle(color: Colors.blue[900]))),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Color _getUrgencyColor(dynamic status) {
    switch (status.toString().toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'urgent':
        return Colors.orange;
      case 'moderate':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  void _showHelpConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Help'),
        content: const Text(
            'The reporter will be notified that you are on your way. Do you have a carrier or medical kit?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('YES, I\'M COMING')),
        ],
      ),
    );
  }
}
