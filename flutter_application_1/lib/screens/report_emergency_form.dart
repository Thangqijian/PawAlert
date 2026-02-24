import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_service.dart';
import '../services/ai_service.dart';
import '../services/location_service.dart'; // Ensure this service exists

class ReportEmergencyForm extends StatefulWidget {
  const ReportEmergencyForm({super.key});

  @override
  _ReportEmergencyFormState createState() => _ReportEmergencyFormState();
}

class _ReportEmergencyFormState extends State<ReportEmergencyForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();
  final AIService _aiService = AIService();
  final LocationService _locationService = LocationService();

  bool _isOtherSelected = false;
  final TextEditingController _otherHelpController = TextEditingController();
  
  // Data Fields
  String _status = 'moderate'; 
  Uint8List? _imageBytes; 
  String? _selectedState;
  String? _selectedCity;
  String _selectedSpecies = 'Dog';
  
  // Type of help needed selection
  final List<String> _allHelpTypes = ['Carrier', 'Transport to Vet', 'Medical Help', 'Food', 'Foster'];
  final List<String> _selectedHelp = [];
  
  Map<String, List<String>> _apiLocations = {};
  bool _isLoadingLocations = true;
  bool _isAnalyzing = false;
  bool _isSubmitting = false;


  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final data = await _locationService.fetchLocations();
    if (mounted) {
      setState(() {
        _apiLocations = data;
        _isLoadingLocations = false;
      });
    }
  }

  Future<void> _handleGPS() async {
    try {
      final names = await _locationService.getCurrentLocationNames();
      String detState = names['state'] ?? '';
      String detCity = names['city'] ?? '';

      setState(() {
        // Find best match for state
        _selectedState = _apiLocations.keys.firstWhere(
          (k) => k.toLowerCase().contains(detState.toLowerCase()) || 
                 detState.toLowerCase().contains(k.toLowerCase()),
          orElse: () => '',
        );

        if (_selectedState != null) {
          // Find best match for city
          _selectedCity = _apiLocations[_selectedState]!.firstWhere(
            (c) => c.toLowerCase().contains(detCity.toLowerCase()),
            orElse: () => '',
          );
        }
      });
      
      if (_selectedState == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location found! Please select State manually.'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS Error. Ensure Emulator location is set.'))
      );
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFFF6B6B)),
              title: const Text('Take Photo'),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFFF6B6B)),
              title: const Text('Choose from Gallery'),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, maxWidth: 800, imageQuality: 85);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  Future<void> _analyzeWithAI() async {
    if (_imageBytes == null || _descriptionController.text.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add photo and description first!')));
      return;
    }
    setState(() => _isAnalyzing = true);
    
    // AI now analyzes image + text to rank urgency
    final result = await _aiService.analyzeEmergencyWithImage(_imageBytes!, _descriptionController.text);
    
    setState(() {
      _status = result['urgency'];
      _isAnalyzing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('AI suggests: ${_status.toUpperCase()} urgency'), backgroundColor: Colors.purple),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate() || _imageBytes == null || _selectedState == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields!')));
      return;
    }

    setState(() => _isSubmitting = true);
    
    final tips = await _aiService.generateSafetyTips(_status, _descriptionController.text);
    
    final postData = {
      'description': _descriptionController.text,
      'status': _status,
      'species': _selectedSpecies,
      'state': _selectedState,
      'location': _selectedCity, // Saved for filtering
      'helpNeeded': _selectedHelp, // New field for help type
      'imageBase64': base64Encode(_imageBytes!),
      'urgencyPriority': _firebaseService.getUrgencyPriority(_status),
      'safetyTips': tips,
      'type': 'Emergency',
      'createdAt': DateTime.now().toIso8601String(),
    };

    await _firebaseService.savePost(postData);
    if (mounted) Navigator.pop(context);
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
            // Image Picker
            GestureDetector(
              onTap: _showImageSourceOptions,
              child: Container(
                height: 180, 
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[300]!)),
                child: _imageBytes != null 
                  ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.memory(_imageBytes!, fit: BoxFit.cover)) 
                  : const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo, size: 40), Text('Add Animal Photo')])),
              ),
            ),
            const SizedBox(height: 20),
            
            // Location Selection
            if (_isLoadingLocations) const LinearProgressIndicator() else ...[
              DropdownButtonFormField<String>(
                value: _selectedState, 
                hint: const Text("Select State"), 
                items: _apiLocations.keys.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), 
                onChanged: (v) => setState(() { _selectedState = v; _selectedCity = null; })
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCity, 
                hint: const Text("Select City"), 
                items: _selectedState == null ? [] : _apiLocations[_selectedState]!.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), 
                onChanged: (v) => setState(() => _selectedCity = v)
              ),
            ],
            TextButton.icon(onPressed: _handleGPS, icon: const Icon(Icons.my_location), label: const Text("Use Current Location")),
            
            const Divider(height: 30),

            // Type of Help Needed
            const Text('Type of Help Needed*', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [..._allHelpTypes, 'Other'].map((type) {
                return FilterChip(
                  label: Text(type, style: const TextStyle(fontSize: 12)),
                  // Check if it's the 'Other' chip or a standard one
                  selected: type == 'Other' ? _isOtherSelected : _selectedHelp.contains(type),
                  onSelected: (selected) {
                    setState(() {
                      if (type == 'Other') {
                        _isOtherSelected = selected;
                      } else {
                        if (selected) {
                          _selectedHelp.add(type);
                        } else {
                          _selectedHelp.remove(type);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),

            // This adds the custom text field only when 'Other' is selected
            if (_isOtherSelected) ...[
              const SizedBox(height: 10),
              TextFormField(
                controller: _otherHelpController,
                decoration: InputDecoration(
                  hintText: "Specify other help needed (e.g., Needs a ladder)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ],

            TextFormField(
              controller: _descriptionController, 
              maxLines: 3, 
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 15),
            
            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeWithAI, 
              icon: const Icon(Icons.auto_awesome), 
              label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze Urgency with AI'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[50], foregroundColor: Colors.purple),
            ),
            const SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm, 
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B), minimumSize: const Size(double.infinity, 50)),
              child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('SUBMIT REPORT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

