import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  // Using your provided API Key (move to .env/secrets in production!)
  static const String _apiKey = 'AIzaSyCojgSUxVNbT8NOnyw0is1rlIvZ0xoi1oA';
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',  
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 1,
        maxOutputTokens: 512,
      ),
    );
  }

  /// Analyzes the photo + text to rank urgency and check for fraud.
  Future<Map<String, dynamic>> analyzeEmergencyWithImage(
      Uint8List imageBytes, String description) async {
    try {
      // IMPROVED PROMPT: Defines clear thresholds for triage
      final prompt = """
        You are an expert veterinary triage assistant. Analyze this photo and description: "$description"
        
        RULES FOR RANKING:
        - CRITICAL: Visible active bleeding, severe wounds, animal is unconscious, or unable to stand.
        - URGENT: Animal is limping, has skin infections/mange, visible pain, or minor wounds.
        - MODERATE: Found a stray, animal is hungry, or healthy but needs rescue/home.

        FRAUD CHECK: Does this look like a real, unique rescue photo or a stock image? 
        
        Return ONLY in this format: RANK | STATUS (e.g., critical | legitimate)
      """;

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),  // ← Correct for this package
        ])
      ];

      final response = await _model.generateContent(content);
      final responseText = response.text ?? "moderate | legitimate";
      final parts = responseText.split('|');

      // Convert image to Base64 for Firestore storage
      String base64Image = base64Encode(imageBytes);

      return {
        'urgency': parts[0].trim().toLowerCase(),
        'isLegitimate': parts.length > 1
            ? parts[1].toLowerCase().contains('legitimate')
            : true,
        'imageBase64': base64Image,
      };
    } catch (e) {
      print('AI Vision Error: $e');
      return {
        'urgency': 'moderate',
        'isLegitimate': true,
        'imageBase64': base64Encode(imageBytes),
      };
    }
  }

  /// Generate 3 safety tips based on the AI rank
  Future<List<String>> generateSafetyTips(
      String urgency, String description) async {
    try {
      final prompt = '''
        You are an animal rescue expert. Generate 3 short, actionable safety tips for someone helping with this $urgency animal emergency:
        Situation: $description
        Format your response exactly like this:
        1. [Tip]
        2. [Tip]
        3. [Tip]
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final result = response.text ?? '';

      final tips = <String>[];
      final lines = result.split('\n');
      for (var line in lines) {
        if (line.trim().startsWith(RegExp(r'[0-9]\.'))) {
          tips.add(line.replaceFirst(RegExp(r'[0-9]\.\s*'), '').trim());
        }
      }
      return tips.isNotEmpty
          ? tips.take(3).toList()
          : _fallbackSafetyTips(urgency);
    } catch (e) {
      print('AI Safety Tips Error: $e');
      return _fallbackSafetyTips(urgency);
    }
  }

  List<String> _fallbackSafetyTips(String urgency) {
    if (urgency == 'critical') {
      return [
        'Call emergency vet immediately before approaching the animal.',
        'Approach slowly and calmly, avoid sudden movements.',
        'Use protective gear if available, watch for aggressive behavior.'
      ];
    } else if (urgency == 'urgent') {
      return [
        'Assess the situation from a safe distance first.',
        'Bring a carrier or blanket to safely transport the animal.',
        'Have vet clinic contact ready before attempting rescue.'
      ];
    } else {
      return [
        'Keep a safe distance until you assess the animal\'s temperament.',
        'Use a blanket or towel to handle the animal if it is small.',
        'Wait for professional rescuers if the animal appears aggressive.'
      ];
    }
  }
}