import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zuvo/constant/app_colors.dart';
import 'package:zuvo/views/home/comments_page.dart';

class ImagePost extends StatefulWidget {
  final String? postId;
  final String url;
  final String text;
  final String? username;
  final String? userEmail;
  final DateTime? timestamp;
  final int likes;
  final int comments;

  const ImagePost({
    super.key,
    this.postId,
    required this.text,
    required this.url,
    this.username,
    this.userEmail,
    this.timestamp,
    this.likes = 0,
    this.comments = 0,
  });

  @override
  State<ImagePost> createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {
  late int likes;
  bool isLiked = false;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    likes = widget.likes;
    _checkLikeStatus();
  }

  Future<void> _checkLikeStatus() async {
    if (widget.postId == null || currentUserId == null) return;
    
    try {
      final doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('likes_by')
          .doc(currentUserId)
          .get();
          
      if (mounted) {
        setState(() {
          isLiked = doc.exists;
        });
      }
    } catch (e) {
      print('Error checking like status: $e');
    }
  }

  Future<void> _toggleLike() async {
    if (widget.postId == null || currentUserId == null) return;

    final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    final likeRef = postRef.collection('likes_by').doc(currentUserId);

    setState(() {
      isLiked = !isLiked;
      isLiked ? likes++ : likes--;
    });

    try {
      if (isLiked) {
        await likeRef.set({'timestamp': DateTime.now()});
        await postRef.update({'likes': FieldValue.increment(1)});
      } else {
        await likeRef.delete();
        await postRef.update({'likes': FieldValue.increment(-1)});
      }
    } catch (e) {
      // Revert on error
      setState(() {
        isLiked = !isLiked;
        isLiked ? likes++ : likes--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.username != null || widget.userEmail != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.username != null)
                    Text(
                      widget.username!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (widget.userEmail != null)
                    Text(
                      widget.userEmail!,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                ],
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.network(
                widget.url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedImageNotFound01,
                    ),
                  );
                },
              ),
            ),
          ),
          if (widget.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          if (widget.timestamp != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                bottom: 8.0,
              ),
              child: Text(
                _formatTime(widget.timestamp!),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                                  children: [
                                    IconButton(
                                      icon: HugeIcon(
                                        icon: HugeIcons.strokeRoundedFavourite,
                                        color: isLiked ? cyberRose : Colors.grey,
                                      ),
                                      onPressed: _toggleLike,
                                    ),
                                    Text('$likes'),
                                  ],                ),
                Row(
                  children: [
                    IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedMessage01,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        if (widget.postId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsPage(
                                postId: widget.postId!,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Text('${widget.comments}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
