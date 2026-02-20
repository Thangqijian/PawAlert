import 'package:flutter/material.dart';
import 'dart:math';
import 'Adoption_Data.dart';
import '/widgets/Adoption/AdoptionCard.dart'; 
import 'Adoption_ApplicantList.dart';
import '../../widgets/app_drawer.dart';



class AdoptionScreen extends StatefulWidget {
  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  String selectedFilter = "All";

  List<Map<String, dynamic>> animals = AdoptionData.animals;

  // Status Badge Color
  Color getStatusColor(String status) {
    switch (status) {
      case "Homeless":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Adopted":
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  // Open Adoption Form Popup
  void openAdoptionForm(Map animal) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final icController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Adopt ${animal["name"]}"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter your name" : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Phone required" : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Email required" : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: icController,
                    decoration: const InputDecoration(
                      labelText: "IC Number",
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "IC required" : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Reason for Adoption",
                      prefixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please write a reason" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              child: const Text("Submit", style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  int aiScore = 70 + Random().nextInt(30);

                  AdoptionData.addApplicant({
                    "pet": animal["name"],
                    "name": nameController.text,
                    "phone": phoneController.text,
                    "email": emailController.text,
                    "ic": icController.text,
                    "reason": reasonController.text,
                    "score": aiScore,
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Application Submitted! AI Score: $aiScore"),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAnimals =
    selectedFilter == "All"
        ? AdoptionData.animals
        : AdoptionData.animals
            .where((a) => a["status"] == selectedFilter)
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Text(
          "🐾 Adoption Center",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.people),
              label: const Text("Applicants"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ApplicantListPage(),
                  ),
                );
              },
            ),
          ),
          Builder(
            builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
          },
        ),
      ),

        ],
      ),

       endDrawer: const AppDrawer(),

      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField(
              value: selectedFilter,
              decoration: InputDecoration(
                labelText: "Filter by Status",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: ["All", "Homeless", "Pending", "Adopted"]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
          ),

          // Animal Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: filteredAnimals.length,
              itemBuilder: (context, index) {
                final animal = filteredAnimals[index];

                return AdoptionCard(
                  animal: animal,
                  statusColor: getStatusColor(animal["status"]),
                  onTap: () {
                    if (animal["status"] == "Homeless") {
                      openAdoptionForm(animal);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
