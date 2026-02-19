import 'package:flutter/material.dart';
import '../screens/raise_fund_form.dart';
import '../screens/case_detail_screen.dart';

class IndividualCaseTab extends StatelessWidget {
  final List<Map<String, dynamic>> cases = [
    {
      'id': '1',
      'title': 'Max needs urgent surgery',
      'description': 'Max was hit by a car and needs leg surgery.',
      'raised': 1700.0,
      'goal': 2500.0,
      'vetQuotation': 'RM 2,500 - includes surgery, medication, and hospitalization',
      'donors': 43,
    },
    {
      'id': '2',
      'title': 'Luna\'s medical treatment',
      'description': 'Luna has skin infection and needs treatment.',
      'raised': 450.0,
      'goal': 800.0,
      'vetQuotation': 'RM 800 - includes antibiotics and follow-up visits',
      'donors': 12,
    },
  ];

  // FIXED: Removed 'const' to allow the 'cases' list above
  IndividualCaseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RaiseFundForm()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Raise Fund for Your Case', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: cases.length,
            itemBuilder: (context, index) {
              final caseData = cases[index];
              // FIXED: We are calculating this...
              final progress = (caseData['raised'] / caseData['goal']) * 100;

              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CaseDetailScreen(caseData: caseData)));
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(child: Text('🐕', style: TextStyle(fontSize: 60))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(caseData['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('Verified', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green[700])),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(caseData['description'], style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                            const SizedBox(height: 12),
                            // FIXED: Added this Text to use the 'progress' variable and fix the warning
                            Text('${progress.toStringAsFixed(0)}% Funded', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green[700])),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: caseData['raised'] / caseData['goal'],
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                              minHeight: 8,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('RM ${caseData['raised'].toStringAsFixed(0)} raised', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
                                Text('of RM ${caseData['goal'].toStringAsFixed(0)}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}