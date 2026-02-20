import 'package:flutter/material.dart';

class ShelterDetailScreen extends StatefulWidget {
  final Map<String, dynamic> shelterData;

  const ShelterDetailScreen({required this.shelterData});

  @override
  _ShelterDetailScreenState createState() => _ShelterDetailScreenState();
}

class _ShelterDetailScreenState extends State<ShelterDetailScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF6B6B),
        title: Text('TNR Shelter', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]),
              ),
              child: Column(
                children: [
                  Text(
                    widget.shelterData['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About This Shelter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text(widget.shelterData['description'], style: TextStyle(fontSize: 15, height: 1.6)),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text('Support TNR Programs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
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
                        SizedBox(height: 12),
                        Row(
                          children: [
                            _quickAmountButton('RM 150', 150),
                            SizedBox(width: 8),
                            _quickAmountButton('RM 300', 300),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _showDonationConfirmation(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF6B6B),
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text('Donate Now', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
        style: OutlinedButton.styleFrom(side: BorderSide(color: Color(0xFFFF6B6B))),
        child: Text(label, style: TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold)),
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
        title: Text('Confirm Donation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('RM ${_amountController.text}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showCuteThankYou(animalsHelped);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6B6B)),
            child: Text('Confirm', style: TextStyle(color: Colors.white)),
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
            Text('🎉', style: TextStyle(fontSize: 60)),
            SizedBox(height: 16),
            Text('Amazing!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[700])),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text('You just helped', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🐕 ', style: TextStyle(fontSize: 30)),
                      Text(
                        '${animalsHelped.toStringAsFixed(1)} animals',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                animalsHelped >= 1 ? animalsHelped.toInt().clamp(1, 5) : 1,
                (index) => Text(index % 2 == 0 ? '🐕' : '🐱', style: TextStyle(fontSize: 35)),
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
            child: Text('Done'),
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