import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Image Upload Service for Zuvo Platform
class ImageUploadService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Pick image from device gallery
  static Future<File?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        return File(result.files.first.path!);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Upload image to Firebase Storage and return download URL
  static Future<String?> uploadImageToStorage(File image) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Check if file exists
      if (!await image.exists()) {
        throw Exception('The local file does not exist at ${image.path}');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$timestamp.jpg';
      final path = 'posts/${user.uid}/$fileName';

      print('DEBUG: Attempting to upload to path: $path');
      final ref = _storage.ref().child(path);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-by': 'Zuvo App'},
      );

      // Upload file
      final uploadTask = ref.putFile(image, metadata);

      // Monitor progress
      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          double progress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          print('DEBUG: Upload progress: ${progress.toStringAsFixed(2)}%');
        },
        onError: (e) {
          print('DEBUG: Stream error during upload: $e');
        },
      );

      // Wait for completion
      final TaskSnapshot snapshot = await uploadTask;
      
      if (snapshot.state == TaskState.success) {
        print('DEBUG: Upload successful, fetching download URL...');
        final downloadUrl = await snapshot.ref.getDownloadURL();
        print('DEBUG: Successfully got download URL: $downloadUrl');
        return downloadUrl;
      } else {
        throw Exception('Upload failed with state: ${snapshot.state}');
      }
    } catch (e) {
      print('CRITICAL: Error in uploadImageToStorage: $e');
      if (e.toString().contains('object-not-found')) {
        print('TIP: This error often means the Storage Bucket is not initialized in the Firebase Console or the rules are blocking access.');
      }
      return null;
    }
  }

  /// Create image post in Firestore
  static Future<bool> createImagePost({
    required String imageUrl,
    required String caption,
    required String username,
    required String email,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.collection('posts').add({
        'uid': user.uid,
        'username': username,
        'email': email,
        'type': 'image',
        'url': imageUrl,
        'content': caption,
        'time': DateTime.now(),
        'likes': 0,
        'comments': 0,
      });

      return true;
    } catch (e) {
      print('Error creating image post: $e');
      return false;
    }
  }

  /// Complete workflow: pick, upload, and create post
  static Future<bool> uploadAndCreateImagePost({
    required String caption,
    required String username,
    required String email,
    required BuildContext context,
  }) async {
    try {
      // Step 1: Pick image
      final image = await pickImage();
      if (image == null) return false;

      // Step 2: Upload to storage
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Uploading image...')));

      final imageUrl = await uploadImageToStorage(image);
      if (imageUrl == null) {
        throw Exception('Failed to get download URL');
      }

      // Step 3: Create post in Firestore
      final success = await createImagePost(
        imageUrl: imageUrl,
        caption: caption,
        username: username,
        email: email,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
        return true;
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return false;
    }
  }
}

/// Widget to add image upload button to post creation
class ImageUploadButton extends StatefulWidget {
  final Function(String imageUrl, String caption) onImageSelected;

  const ImageUploadButton({required this.onImageSelected, super.key});

  @override
  State<ImageUploadButton> createState() => _ImageUploadButtonState();
}

class _ImageUploadButtonState extends State<ImageUploadButton> {
  bool _isUploading = false;
  File? _selectedImage;

  Future<void> _handleImageUpload() async {
    setState(() => _isUploading = true);

    try {
      final image = await ImageUploadService.pickImage();
      if (image != null) {
        setState(() => _selectedImage = image);

        // Show dialog for caption
        if (mounted) {
          _showCaptionDialog();
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showCaptionDialog() {
    final captionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Caption'),
        content: TextField(
          controller: captionController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Add a caption to your image...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Upload image
              final imageUrl = await ImageUploadService.uploadImageToStorage(
                _selectedImage!,
              );

              if (imageUrl != null) {
                widget.onImageSelected(imageUrl, captionController.text);
                setState(() => _selectedImage = null);
              }
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isUploading ? null : _handleImageUpload,
      icon: _isUploading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.image),
      label: Text(_isUploading ? 'Uploading...' : 'Add Image'),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
