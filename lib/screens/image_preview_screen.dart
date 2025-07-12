import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'diagnosis_screen.dart';

class PickImageScreen extends StatefulWidget {
  const PickImageScreen({super.key});

  @override
  State<PickImageScreen> createState() => _PickImageScreenState();
}

class _PickImageScreenState extends State<PickImageScreen> with SingleTickerProviderStateMixin {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _iconAnimController;

  @override
  void initState() {
    super.initState();
    _iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _iconAnimController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Choose from Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a Photo"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _cancelImageSelection() {
    setState(() {
      _image = null;
    });
  }

  void _submitForDiagnosis() {
    if (_image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiagnosisScreen(imageFile: _image!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Capture Plant Image 🌿', 
          style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _image == null
            ? _buildEmptyState()
            : _buildPreviewState(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showImageSourceOptions,
        icon: const Icon(Icons.add_a_photo),
        label: const Text("Add Image"),
        backgroundColor: Colors.teal.shade50,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.05).animate(CurvedAnimation(
                parent: _iconAnimController,
                curve: Curves.easeInOut,
              )),
              child: Icon(Icons.add_photo_alternate_rounded,
                  size: 100, color: Colors.teal.shade400),
            ),
            const SizedBox(height: 30),
            Text(
              "No Image Selected",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Tap the button below to capture or upload a plant image for smart disease diagnosis.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewState() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Material(
                elevation: 6,
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: Image.file(
                    _image!,
                    fit: BoxFit.contain, // ✅ Show full image
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 80), // ✅ Avoid overlap with FAB
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _cancelImageSelection,
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text("Cancel"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _submitForDiagnosis,
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Diagnose"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade100,
                    foregroundColor: const Color.fromARGB(255, 53, 32, 103),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
