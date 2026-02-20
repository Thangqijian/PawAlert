import 'package:flutter/material.dart';
import 'Adoption_Data.dart';

class ApplicantDetailPage extends StatelessWidget {
  final Map<String, dynamic> applicant;

  const ApplicantDetailPage({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Text(
          "Applicant Details",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👤 Profile Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.pink[100],
                      child: const Icon(Icons.person, size: 35),
                    ),

                    const SizedBox(width: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          applicant["name"],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Applying for: ${applicant["pet"]}",
                          style: const TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Score: ${applicant["score"]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text("Contact Information",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Text("📞 Phone: ${applicant["phone"]}"),
            Text("📧 Email: ${applicant["email"]}"),
            Text("🆔 IC: ${applicant["ic"]}"),

            const SizedBox(height: 25),

            const Text("Reason for Adoption",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(applicant["reason"]),
            ),

            const Spacer(),

            // ✅ Approve Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Approve Application",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {

                  // Update animal status
                  AdoptionData.updateAnimalStatus(
                      applicant["pet"], "Adopted");

                  // Add notification
                  AdoptionData.addNotification(
                    "Application Approved 🎉",
                    "${applicant["name"]} approved to adopt ${applicant["pet"]}",
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Applicant Approved Successfully!"),
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}