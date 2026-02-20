import 'package:flutter/material.dart';
import 'Adoption_Data.dart';
import 'Adoption_ApplicantDetails.dart';

class ApplicantListPage extends StatelessWidget {
  const ApplicantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Text(
          "Applicants (AI Ranked)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
       ),
      body: ListView.builder(
        itemCount: AdoptionData.applicants.length,
        itemBuilder: (context, index) {
          final applicant = AdoptionData.applicants[index];

          return Card(
            child: ListTile(
              title: Text(applicant["name"]),
              subtitle: Text("Pet: ${applicant["pet"]}"),
              trailing: Text("Score: ${applicant["score"]}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ApplicantDetailPage(applicant: applicant),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
