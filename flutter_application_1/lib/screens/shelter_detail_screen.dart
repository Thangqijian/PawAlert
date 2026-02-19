import 'package:flutter/material.dart';

class ShelterDetailScreen extends StatefulWidget {
  final Map<String, dynamic> shelterData;

  const ShelterDetailScreen({super.key, required this.shelterData});

  @override
  _ShelterDetailScreenState createState() => _ShelterDetailScreenState();
}

class _ShelterDetailScreenState extends State<ShelterDetailScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Text('TNR Shelter', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]),
              ),
              child: Column(
                children: [
                  Text(
                    widget.shelterData['name'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About This Shelter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(widget.shelterData['description'], style: const TextStyle(fontSize: 15, height: 1.6)),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text('Support TNR Programs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter amount',
                            prefixText: 'RM ',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _quickAmountButton('RM 150', 150),
                            const SizedBox(width: 8),
                            _quickAmountButton('RM 300', 300),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _showDonationConfirmation(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B6B),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Donate Now', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
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

  Widget _quickAmountButton(String label, int amount) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _amountController.text = amount.toString();
          });
        },
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFF6B6B))),
        child: Text(label, style: const TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showDonationConfirmation() {
    if (_amountController.text.isEmpty) return;

    final amount = double.parse(_amountController.text);
    final animalsHelped = amount / widget.shelterData['costPerAnimal'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Donation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('RM ${_amountController.text}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showCuteThankYou(animalsHelped);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B)),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCuteThankYou(double animalsHelped) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text('Amazing!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[700])),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text('You just helped', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🐕 ', style: TextStyle(fontSize: 30)),
                      Text(
                        '${animalsHelped.toStringAsFixed(1)} animals',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                animalsHelped >= 1 ? animalsHelped.toInt().clamp(1, 5) : 1,
                (index) => Text(index % 2 == 0 ? '🐕' : '🐱', style: const TextStyle(fontSize: 35)),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}