import 'package:flutter/material.dart';
import '../widgets/individual_case_tab.dart';
import '../widgets/tnr_shelter_tab.dart';

class DonationScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF6B6B),
          title: Row(
            children: [
              Text('💰 ', style: TextStyle(fontSize: 24)),
              Text('Donations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'Individual Cases'),
              Tab(text: 'TNR Programs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            IndividualCaseTab(),
            TNRShelterTab(),
          ],
        ),
      ),
    );
  }
}