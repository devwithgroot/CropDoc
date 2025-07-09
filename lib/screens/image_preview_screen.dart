import 'dart:io'; // Required for File operations

import 'package:flutter/material.dart'; // Core Flutter material design widgets
import 'package:image_picker/image_picker.dart'; // Package for picking images from gallery or camera
import 'diagnosis_screen.dart'; // Import the new diagnosis screen

class PickImageScreen extends StatefulWidget {
  const PickImageScreen({super.key}); // Constructor for the widget

  @override
  State<PickImageScreen> createState() => _PickImageScreenState(); // Create the state for this widget
}

class _PickImageScreenState extends State<PickImageScreen> {
  File? _image; // Variable to store the picked image file
  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker to use for picking images

  // Function to pick an image from a specified source (camera or gallery)
  Future<void> _pickImage(ImageSource source) async {
    try {
      // Use the picker to get an image from the given source
      final XFile? pickedFile = await _picker.pickImage(source: source);

      // If a file was picked successfully
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Update the _image variable with the new file
        });
      } else {
        // Optionally, show a message if no image was picked
        debugPrint('No image selected.');
      }
    } catch (e) {
      // Handle any errors that occur during image picking
      debugPrint('Error picking image: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // Function to show a modal bottom sheet with camera and gallery options
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea( // Ensures content is not obscured by system UI
          child: Column(
            mainAxisSize: MainAxisSize.min, // Make the column take minimum space
            children: <Widget>[
              // Option to pick image from gallery
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _pickImage(ImageSource.gallery); // Call pickImage with gallery source
                },
              ),
              // Option to take photo with camera
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _pickImage(ImageSource.camera); // Call pickImage with camera source
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to reset the image selection (acts as "Cancel" for the current image)
  void _cancelImageSelection() {
    setState(() {
      _image = null; // Clear the selected image
    });
  }

  // Function to submit the image for diagnosis
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
        const SnackBar(content: Text('Please select an image first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Pop the current screen off the navigation stack
          },
        ),
      ),
      body: Center(
        child: _image == null
            ? const Text(
                "No Image Picked",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.file(
                        _image!, // Display the picked image
                        fit: BoxFit.contain, // Adjust how the image fits within its bounds
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _cancelImageSelection,
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Red color for cancel
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _submitForDiagnosis,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Submit for Diagnosis'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Green color for submit
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImageSourceOptions, // Call the function to show options
        child: const Icon(Icons.add_a_photo), // Icon to suggest adding a photo
      ),
    );
  }
}
