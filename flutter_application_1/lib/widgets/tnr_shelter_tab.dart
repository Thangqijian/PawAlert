import 'package:flutter/material.dart';
import '../screens/shelter_detail_screen.dart';

class TNRShelterTab extends StatelessWidget {
  final List<Map<String, dynamic>> shelters = [
    {
      'id': '1',
      'name': '🏥 PJ Animal Clinic',
      'distance': 0.8,
      'tnrCompleted': 52,
      'currentFund': 3200,
      'costPerAnimal': 150,
      'description': 'Professional vet clinic specializing in TNR programs.',
    },
    {
      'id': '2',
      'name': '🏠 Hope Shelter PJ',
      'distance': 2.3,
      'tnrCompleted': 38,
      'currentFund': 1850,
      'costPerAnimal': 120,
      'description': 'Community-run shelter focused on stray population control.',
    },
  ];

  // FIXED: Removed 'const' here
  TNRShelterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)]),
            borderRadius: BorderRadius.circular(12),
          ),
          // FIXED: Removed 'const' from this Column
          child: Column(
            children: [
              const Text('147', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
              const SizedBox(height: 8),
              const Text(
                'Animals helped through TNR in\nPetaling Jaya this month',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF558B2F)),
              ),
            ],
          ),
        ),
        ...shelters.map((shelter) => _buildShelterCard(context, shelter)),
      ],
    );
  }

  Widget _buildShelterCard(BuildContext context, Map<String, dynamic> shelter) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShelterDetailScreen(shelterData: shelter)));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(shelter['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Partner', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[700])),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildStatRow('📍 Distance', '${shelter['distance']} km away'),
                    const SizedBox(height: 10),
                    _buildStatRow('✂️ TNR Completed', '${shelter['tnrCompleted']} animals'),
                    const SizedBox(height: 10),
                    _buildStatRow('💰 Current Fund', 'RM ${shelter['currentFund']}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(shelter['description'], style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShelterDetailScreen(shelterData: shelter)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Donate to TNR Fund', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
      ],
    );
  }
}