import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // From your updated pubspec
import '../services/firebase_service.dart';
import '../services/ai_service.dart';

class ReportEmergencyForm extends StatefulWidget {
  const ReportEmergencyForm({super.key});

  @override
  _ReportEmergencyFormState createState() => _ReportEmergencyFormState();
}

class _ReportEmergencyFormState extends State<ReportEmergencyForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();
  final AIService _aiService = AIService();
  
  // Form fields
  String _status = 'moderate'; 
  final String _location = 'GPS Location';
  Uint8List? _imageBytes; 
  
  bool _isAnalyzing = false;
  bool _isSubmitting = false;

  final TextEditingController _descriptionController = TextEditingController();

  // 1. Updated Pick Image function (Flexible for Camera/Gallery)
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800, // Important for Base64 string length
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() => _imageBytes = bytes);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // 2. The Popup Menu (UX Polish)
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Select Image Source', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFFF6B6B)),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFFF6B6B)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // AI Logic
  Future<void> _analyzeWithAI() async {
    if (_imageBytes == null || _descriptionController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a photo and a short description first!')),
      );
      return;
    }
    
    setState(() => _isAnalyzing = true);
    
    try {
      final result = await _aiService.analyzeEmergencyWithImage(_imageBytes!, _descriptionController.text);
      
      setState(() {
        _status = result['urgency'];
        _isAnalyzing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✨ AI suggests: ${_status.toUpperCase()}'), backgroundColor: Colors.purple),
      );
    } catch (e) {
      setState(() => _isAnalyzing = false);
      debugPrint("AI Error: $e");
    }
  }

  // Submission Logic
  void _submitForm() async {
    if (!_formKey.currentState!.validate() || _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo and Description are required!')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final postData = {
        'description': _descriptionController.text,
        'type': 'Emergency',
        'status': _status,
        'imageBase64': base64Encode(_imageBytes!),
        'urgencyPriority': _firebaseService.getUrgencyPriority(_status),
        'location': _location,
      };

      await _firebaseService.savePost(postData);
      
      if (mounted) {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency Reported!')));
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        title: const Text('Report Emergency', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // IMAGE PICKER UI
            GestureDetector(
              onTap: _showImageSourceOptions, // Connected to the new menu
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _imageBytes != null 
                  ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.memory(_imageBytes!, fit: BoxFit.cover))
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.add_a_photo, size: 50, color: Colors.grey), Text('Add Animal Photo')],
                    ),
              ),
            ),
            const SizedBox(height: 20),
            
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'What happened?',
                hintText: 'e.g., Dog hit by car at the junction...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => v!.isEmpty ? 'Description required' : null,
            ),
            
            const SizedBox(height: 15),
            
            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeWithAI,
              icon: const Icon(Icons.auto_awesome),
              label: Text(_isAnalyzing ? 'AI is Thinking...' : 'Analyze with Gemini AI'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[50], 
                foregroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 45)
              ),
            ),
            
            const SizedBox(height: 25),
            
            const Text('Severity Rank', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['moderate', 'urgent', 'critical'].map((level) {
                return ChoiceChip(
                  label: Text(level.toUpperCase()),
                  selected: _status == level,
                  onSelected: (s) => setState(() => _status = level),
                  selectedColor: const Color(0xFFFF6B6B),
                  labelStyle: TextStyle(color: _status == level ? Colors.white : Colors.black),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSubmitting 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text('SUBMIT EMERGENCY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}