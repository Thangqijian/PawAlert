import 'package:flutter/material.dart';

class CaseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> caseData;

  const CaseDetailScreen({required this.caseData});

  @override
  _CaseDetailScreenState createState() => _CaseDetailScreenState();
} 

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final progress = (widget.caseData['raised'] / widget.caseData['goal']) * 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF6B6B),
        title: Text('Case Details', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.flag_outlined, color: Colors.white),
            onPressed: () => _showReportDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              color: Colors.grey[300],
              child: Center(child: Text('🐕', style: TextStyle(fontSize: 80))),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.caseData['title'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
                            SizedBox(width: 6),
                            Text('Verified', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green[700])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RM ${widget.caseData['raised'].toStringAsFixed(0)}',
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[700]),
                                ),
                                Text('raised of RM ${widget.caseData['goal'].toStringAsFixed(0)}'),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF6B6B),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${progress.toStringAsFixed(0)}%',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: widget.caseData['raised'] / widget.caseData['goal'],
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            minHeight: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text('About This Case', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text(widget.caseData['description'], style: TextStyle(fontSize: 15, height: 1.6)),
                  SizedBox(height: 24),
                  Text('Vet Quotation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(widget.caseData['vetQuotation']),
                  ),
                  SizedBox(height: 30),
                  Text('Enter Donation Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: 'RM ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _quickAmountButton('RM 50', 50),
                      SizedBox(width: 8),
                      _quickAmountButton('RM 100', 100),
                      SizedBox(width: 8),
                      _quickAmountButton('RM 200', 200),
                    ],
                  ),
                  SizedBox(height: 24),
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
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFFFF6B6B)),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(label, style: TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showDonationConfirmation() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter donation amount')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Donation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.volunteer_activism, size: 60, color: Color(0xFFFF6B6B)),
            SizedBox(height: 16),
            Text('RM ${_amountController.text}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showThankYou();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6B6B)),
            child: Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showThankYou() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎉', style: TextStyle(fontSize: 60)),
            SizedBox(height: 16),
            Text('Thank You!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('Your donation has been received!'),
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

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.flag, color: Colors.red),
            SizedBox(width: 10),
            Text('Report Scam'),
          ],
        ),
        content: Text('Are you sure you want to report this case?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Report submitted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Report', style: TextStyle(color: Colors.white)),
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