import 'dart:convert'; // Required for Base64 decoding
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'report_emergency_form.dart';
import 'emergency_detail_screen.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  int _viewMode = 0; // 0 = feed, 1 = grid

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Row(
          children: [
            Text('🚨 ', style: TextStyle(fontSize: 24)),
            Text('Emergency Help',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_viewMode == 0 ? Icons.grid_view : Icons.view_list,
                color: Colors.white),
            onPressed: () => setState(() => _viewMode = _viewMode == 0 ? 1 : 0),
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort header removed to keep UI clean and forced to urgency
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              // Always sort by urgency level (Critical > Urgent > Moderate)
              stream: _firebaseService.getCasesByUrgency(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFFF6B6B)));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final cases = snapshot.data ?? [];

                if (cases.isEmpty) {
                  return _buildEmptyState();
                }

                return _viewMode == 0
                    ? _buildFeedView(cases)
                    : _buildGridView(cases);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportEmergencyForm()),
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Report Emergency',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildFeedView(List<Map<String, dynamic>> cases) {
    return ListView.builder(
      itemCount: cases.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) => _buildCaseCard(cases[index]),
    );
  }

  Widget _buildCaseCard(Map<String, dynamic> data) {
    final imageWidget = (data['imageBase64'] != null &&
            data['imageBase64'].isNotEmpty)
        ? Image.memory(base64Decode(data['imageBase64']), fit: BoxFit.cover)
        : const Center(child: Icon(Icons.pets, size: 40, color: Colors.grey));

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8), child: imageWidget)),
        title: Text(data['status'].toString().toUpperCase(),
            style: TextStyle(
                color: _getUrgencyColor(data['status']),
                fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show the State and City
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 14, color: Color(0xFFFF6B6B)),
                const SizedBox(width: 4),
                Text("${data['location']}, ${data['state']}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 5),
            Text(data['description'] ?? '',
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 5),
            // Show how many things they need help with
            Text(
                "${(data['helpNeeded'] as List?)?.length ?? 0} items requested",
                style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
          ],
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmergencyDetailScreen(caseData: data))),
      ),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> cases) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: cases.length,
      itemBuilder: (context, index) => _buildGridItem(cases[index]),
    );
  }

  Widget _buildGridItem(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmergencyDetailScreen(caseData: data))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
                child: data['imageBase64'] != null
                    ? Image.memory(base64Decode(data['imageBase64']),
                        fit: BoxFit.cover)
                    : Container(color: Colors.grey[200])),
            Container(color: Colors.black26),
            Positioned(
                bottom: 10,
                left: 10,
                child: Text(data['status'].toString().toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        ),
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

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🚨', style: TextStyle(fontSize: 60)),
          SizedBox(height: 10),
          Text('No emergencies reported.',
              style: TextStyle(color: Colors.grey, fontSize: 18)),
        ],
      ),
    );
  }
}
