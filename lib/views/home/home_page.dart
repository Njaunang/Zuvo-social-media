import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zuvo/constant/app_colors.dart';
import 'package:zuvo/l10n/app_localizations.dart';
import 'package:zuvo/services/image_upload_service.dart';
import 'package:zuvo/util/image_post.dart';
import 'package:zuvo/util/text_post.dart';
import 'package:zuvo/util/toast_notification.dart';
import 'package:zuvo/widgets/greeting.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final postText = TextEditingController();
  bool _isPosting = false;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final image = await ImageUploadService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _createPost() async {
    if (postText.text.trim().isEmpty && _selectedImage == null) {
      ToastNotification.showError(
        context,
        title: AppLocalizations.of(context)!.empty_post_title,
        description: AppLocalizations.of(context)!.empty_post_describtion,
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await ImageUploadService.uploadImageToStorage(
          _selectedImage!,
        );
      }

      var data = {
        'time': DateTime.now(),
        'type': imageUrl != null ? 'image' : 'text',
        'content': postText.text.trim(),
        'url': imageUrl,
        'uid': user!.uid,
        'username':
            user!.displayName ?? AppLocalizations.of(context)!.anonymous,
        'email': user!.email,
        'likes': 0,
        'comments': 0,
      };
      await FirebaseFirestore.instance.collection('posts').add(data);

      if (mounted) {
        postText.clear();
        setState(() {
          _selectedImage = null;
        });
        ToastNotification.showSuccess(
          context,
          title: AppLocalizations.of(context)!.success_title,
          description: AppLocalizations.of(context)!.post_successful,
        );
      }
    } catch (e) {
      if (mounted) {
        ToastNotification.showError(
          context,
          title: AppLocalizations.of(context)!.error_title,
          description: AppLocalizations.of(context)!.post_failed,
        );
        // print('$e');
      }
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  @override
  void dispose() {
    postText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Greeting(),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: postText,
                      maxLines: null,
                      enabled: !_isPosting,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.post_hintext,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: HugeIcon(icon: HugeIcons.strokeRoundedIdea),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _isPosting ? null : _pickImage,
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedImageAdd01,
                            color: cyberRose,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    if (_selectedImage != null)
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 12,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: _isPosting ? null : _createPost,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(icon: HugeIcons.strokeRoundedTelegram),
                          const SizedBox(width: 8),
                          _isPosting
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      cyberRose,
                                    ),
                                  ),
                                )
                              : Text(AppLocalizations.of(context)!.post_button),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(cyberRose),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.no_post_yet),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var postDoc = snapshot.data!.docs[index];
                      var postData = postDoc.data() as Map;
                      var postId = postDoc.id;

                      switch (postData['type']) {
                        case 'text':
                          return TextPost(
                            postId: postId,
                            text: postData['content'] ?? '',
                            username:
                                postData['username'] ??
                                AppLocalizations.of(context)!.anonymous,
                            userEmail: postData['email'],
                            timestamp: (postData['time'] as Timestamp?)
                                ?.toDate(),
                            likes: postData['likes'] ?? 0,
                            comments: postData['comments'] ?? 0,
                          );
                        case 'image':
                          return ImagePost(
                            postId: postId,
                            text: postData['content'] ?? '',
                            url: postData['url'] ?? '',
                            username:
                                postData['username'] ??
                                AppLocalizations.of(context)!.anonymous,
                            userEmail: postData['email'],
                            timestamp: (postData['time'] as Timestamp?)
                                ?.toDate(),
                            likes: postData['likes'] ?? 0,
                            comments: postData['comments'] ?? 0,
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
