class AdoptionData {

   static List<Map<String, dynamic>> animals = [
    {
      "id": 1,
      "name": "Max",
      "description": "Friendly puppy rescued from roadside.",
      "status": "Homeless",
      "age": "3 months",
      "location": "Kuala Lumpur",
      "image": "assets/images/Image1.jpg"
    },
    {
      "id": 2,
      "name": "Luna",
      "description": "Calm kitten looking for a safe home.",
      "status": "Homeless",
      "age": "6 months",
      "location": "Petaling Jaya",
      "image": "assets/images/Image2.jpg"
    },
    {
      "id": 3,
      "name": "Rocky",
      "description": "Healthy dog ready for adoption.",
      "status": "Adopted",
      "age": "1 year",
      "location": "Shah Alam",
      "image": "assets/images/Image3.jpg"
    },
  ];
  
  static List<Map<String, dynamic>> applicants = [
  {
    "pet": "Max",
    "name": "Jason Tan",
    "phone": "0123456789",
    "email": "jason@gmail.com",
    "ic": "990101-10-1234",
    "reason": "I have experience raising dogs and a large backyard.",
    "score": 92,
  },
  {
    "pet": "Max",
    "name": "Alicia Wong",
    "phone": "0178889999",
    "email": "alicia@gmail.com",
    "ic": "980505-08-5678",
    "reason": "I love animals and work from home.",
    "score": 88,
  },
  {
    "pet": "Luna",
    "name": "Daniel Lim",
    "phone": "0191234567",
    "email": "daniel@gmail.com",
    "ic": "000707-14-4321",
    "reason": "I want to adopt a kitten for companionship.",
    "score": 85,
  },
];
  static void addApplicant(Map<String, dynamic> applicant) {
    applicants.add(applicant);

    // Sort applicants by AI score (highest first)
    applicants.sort((a, b) => b["score"].compareTo(a["score"]));
  }

   static List<Map<String, dynamic>> notifications = [];

  static void addNotification(String title, String message) {
    notifications.insert(0, {
      "title": title,
      "message": message,
      "time": DateTime.now(),
    });
  }

  static void updateAnimalStatus(String petName, String newStatus) {
    final animal =
        animals.firstWhere((animal) => animal["name"] == petName);
    animal["status"] = newStatus;
  }
}
