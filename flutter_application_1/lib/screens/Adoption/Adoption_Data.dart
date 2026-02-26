class AdoptionData {
  static List<Map<String, dynamic>> animals = [
    {
      "id": 1,
      "name": "Max",
      "description": "Friendly golden puppy rescued from roadside. Loves to play fetch and cuddle. Great with kids and other animals. Has been dewormed and is very healthy.",
      "status": "Homeless",
      "age": "3 months",
      "sex": "Male",
      "breed": "Golden Mix",
      "weight": "2.5 kg",
      "vaccinated": true,
      "location": "Kuala Lumpur",
      "distance": 1.2,
      "tags": ["Playful", "Friendly", "Outdoor"],
      "image": "images/Image1.jpg",
      "ownerName": "Ahmad Razif",
      "ownerPhone": "0123456789",
      "ownerEmail": "ahmad@gmail.com",
      "ownerId": "owner_001",
      "favourites": 12,
      "animalType": "Dog",
      "postedDate": "2024-01-15",
    },
    {
      "id": 2,
      "name": "Luna",
      "description": "Calm and gentle kitten looking for a loving indoor home. Litter trained and loves to sit on laps. She gets along well with children and is very quiet.",
      "status": "Homeless",
      "age": "6 months",
      "sex": "Female",
      "breed": "Domestic Shorthair",
      "weight": "1.8 kg",
      "vaccinated": true,
      "location": "Petaling Jaya",
      "distance": 2.3,
      "tags": ["Quiet", "Indoor", "Snuggly"],
      "image": "images/Image2.jpg",
      "ownerName": "Siti Aisyah",
      "ownerPhone": "0178889999",
      "ownerEmail": "siti@gmail.com",
      "ownerId": "owner_002",
      "favourites": 8,
      "animalType": "Cat",
      "postedDate": "2024-01-18",
    },
    {
      "id": 3,
      "name": "Rocky",
      "description": "Energetic and healthy dog who loves outdoor adventures. Good with families and has basic obedience training. Knows sit, stay, and shake.",
      "status": "Adopted",
      "age": "1 year",
      "sex": "Male",
      "breed": "Labrador Mix",
      "weight": "8.0 kg",
      "vaccinated": true,
      "location": "Shah Alam",
      "distance": 4.5,
      "tags": ["Active", "Trained", "Outdoor"],
      "image": "images/Image3.jpg",
      "ownerName": "Raj Kumar",
      "ownerPhone": "0191234567",
      "ownerEmail": "raj@gmail.com",
      "ownerId": "owner_003",
      "favourites": 24,
      "animalType": "Dog",
      "postedDate": "2024-01-10",
    },
    {
      "id": 4,
      "name": "Mochi",
      "description": "Super fluffy and affectionate Persian mix rescued from an abandoned house. She loves being brushed and will purr non-stop when you pet her.",
      "status": "Homeless",
      "age": "2 years",
      "sex": "Female",
      "breed": "Persian Mix",
      "weight": "3.2 kg",
      "vaccinated": true,
      "location": "Subang Jaya",
      "distance": 3.1,
      "tags": ["Snuggly", "Indoor", "Quiet"],
      "image": "images/Image2.jpg",
      "ownerName": "Wei Ling",
      "ownerPhone": "0112345678",
      "ownerEmail": "weiling@gmail.com",
      "ownerId": "owner_004",
      "favourites": 31,
      "animalType": "Cat",
      "postedDate": "2024-01-20",
    },
    {
      "id": 5,
      "name": "Buddy",
      "description": "Cheerful and loyal medium-sized dog. Found wandering near Chow Kit. Has been neutered, microchipped, and is fully vaccinated. Loves car rides and fetch.",
      "status": "Homeless",
      "age": "2 years",
      "sex": "Male",
      "breed": "Mixed Breed",
      "weight": "12.0 kg",
      "vaccinated": true,
      "location": "Chow Kit, KL",
      "distance": 0.8,
      "tags": ["Friendly", "Active", "Trained"],
      "image": "images/Image1.jpg",
      "ownerName": "Daniel Foo",
      "ownerPhone": "0167891234",
      "ownerEmail": "daniel@gmail.com",
      "ownerId": "owner_005",
      "favourites": 19,
      "animalType": "Dog",
      "postedDate": "2024-01-22",
    },
    {
      "id": 6,
      "name": "Kiwi",
      "description": "Bright green parakeet who loves to sing and whistle. Hand-tamed and very social. Comes with cage and accessories. Previous owner moved abroad.",
      "status": "Homeless",
      "age": "1 year",
      "sex": "Male",
      "breed": "Budgerigar",
      "weight": "0.04 kg",
      "vaccinated": false,
      "location": "Ampang",
      "distance": 5.2,
      "tags": ["Playful", "Vocal", "Indoor"],
      "image": "image/Image1.jpg",
      "ownerName": "Priya Nair",
      "ownerPhone": "0134567890",
      "ownerEmail": "priya@gmail.com",
      "ownerId": "owner_006",
      "favourites": 6,
      "animalType": "Bird",
      "postedDate": "2024-01-23",
    },
    {
      "id": 7,
      "name": "Snowball",
      "description": "Pure white fluffy rabbit who loves to hop around. Litter trained and very easy to handle. Great for apartments. Comes with hutch and food supply.",
      "status": "Pending",
      "age": "8 months",
      "sex": "Female",
      "breed": "Angora Mix",
      "weight": "1.5 kg",
      "vaccinated": false,
      "location": "Bangsar",
      "distance": 2.8,
      "tags": ["Gentle", "Indoor", "Quiet"],
      "image": "image/Image2.jpg",
      "ownerName": "Hafizah Zain",
      "ownerPhone": "0145678901",
      "ownerEmail": "hafizah@gmail.com",
      "ownerId": "owner_007",
      "favourites": 14,
      "animalType": "Rabbit",
      "postedDate": "2024-01-25",
    },
  ];

  // Simulated current user ID
  static String currentUserId = "current_user";
  static String currentUserName = "You";

  // Track which animal chats have been initiated — persists slide button green state
  static Set<String> contactedChats = {};

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

  // Chat conversations: key = "userId_ownerId_animalId"
  static Map<String, List<Map<String, dynamic>>> chatMessages = {};

  static List<Map<String, dynamic>> getChatMessages(String chatId) {
    return chatMessages[chatId] ?? [];
  }

  static void sendMessage(
      String chatId, String senderId, String senderName, String message) {
    if (!chatMessages.containsKey(chatId)) {
      chatMessages[chatId] = [];
    }
    chatMessages[chatId]!.add({
      "senderId": senderId,
      "senderName": senderName,
      "message": message,
      "time": DateTime.now(),
    });
  }

  // Chat list: all conversations for current user
  static List<Map<String, dynamic>> chatList = [];

  static String getChatId(int animalId, String ownerId) {
    return "${currentUserId}_${ownerId}_$animalId";
  }

  static bool hasContacted(int animalId, String ownerId) {
    return contactedChats.contains(getChatId(animalId, ownerId));
  }

  static void startOrOpenChat({
    required int animalId,
    required String animalName,
    required String ownerId,
    required String ownerName,
    required String ownerPhone,
    String? initialMessage,
  }) {
    String chatId = getChatId(animalId, ownerId);

    bool exists = chatList.any((c) => c["chatId"] == chatId);
    if (!exists) {
      chatList.add({
        "chatId": chatId,
        "animalId": animalId,
        "animalName": animalName,
        "ownerId": ownerId,
        "ownerName": ownerName,
        "ownerPhone": ownerPhone,
      });
    }

    // Mark as contacted so slide button stays green
    contactedChats.add(chatId);

    // Send initial message only if it's a brand new chat
    if (initialMessage != null && !exists) {
      sendMessage(chatId, currentUserId, currentUserName, initialMessage);
      // Simulate auto-reply from owner after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        sendMessage(
          chatId,
          ownerId,
          ownerName,
          "Hi! Thanks for your interest in $animalName 🐾 Feel free to ask me anything!",
        );
      });
    }
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
    final animal = animals.firstWhere((animal) => animal["name"] == petName);
    animal["status"] = newStatus;
  }

  static void addApplicant(Map<String, dynamic> applicant) {
    applicants.add(applicant);
    applicants.sort((a, b) => b["score"].compareTo(a["score"]));
  }

  static void toggleFavourite(int animalId) {
    final animal = animals.firstWhere((a) => a["id"] == animalId);
    bool isFav = animal["isFavourited"] ?? false;
    animal["isFavourited"] = !isFav;
    if (!isFav) {
      animal["favourites"] = (animal["favourites"] ?? 0) + 1;
    } else {
      animal["favourites"] = (animal["favourites"] ?? 1) - 1;
    }
  }

  static void addAnimalPost(Map<String, dynamic> animal) {
    animals.insert(0, animal);
  }
}