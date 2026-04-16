import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zuvo/constant/app_colors.dart';
import 'package:zuvo/l10n/app_localizations.dart';
import 'package:zuvo/views/messages/chat_page.dart';

// Follow Button Widget
class FollowButton extends StatefulWidget {
  final DocumentSnapshot userDoc;

  const FollowButton({required this.userDoc, super.key});

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    try {
      final docSnapshot = await widget.userDoc.reference
          .collection('followers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (mounted) {
        setState(() {
          _isFollowing = docSnapshot.exists;
        });
      }
    } catch (e) {
      print('Error checking follow status: $e');
    }
  }

  Future<void> _toggleFollow() async {
    setState(() => _isLoading = true);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final batch = FirebaseFirestore.instance.batch();

      if (_isFollowing) {
        // Unfollow
        batch.delete(
          widget.userDoc.reference.collection('followers').doc(currentUserId),
        );

        batch.update(widget.userDoc.reference, {
          'followers_count': FieldValue.increment(-1),
        });

        batch.update(
          FirebaseFirestore.instance.collection('users').doc(currentUserId),
          {'following_count': FieldValue.increment(-1)},
        );
      } else {
        // Follow
        batch.set(
          widget.userDoc.reference.collection('followers').doc(currentUserId),
          {'timestamp': DateTime.now()},
        );

        batch.update(widget.userDoc.reference, {
          'followers_count': FieldValue.increment(1),
        });

        batch.update(
          FirebaseFirestore.instance.collection('users').doc(currentUserId),
          {'following_count': FieldValue.increment(1)},
        );
      }

      await batch.commit();

      if (mounted) {
        setState(() {
          _isFollowing = !_isFollowing;
        });
      }
    } catch (e) {
      print('Error toggling follow: $e');
      if (mounted) {
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Error: $e')));
        print("Error: $e");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 40,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _toggleFollow,
        child: _isLoading
            ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(softOffWhite),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _isFollowing
                      ? HugeIcon(
                          icon: HugeIcons.strokeRoundedLinkBackward,
                          size: 14,
                          color: softOffWhite,
                        )
                      : HugeIcon(
                          icon: HugeIcons.strokeRoundedLinkForward,
                          size: 14,
                          color: softOffWhite,
                        ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      _isFollowing
                          ? AppLocalizations.of(context)!.un_follow_button
                          : AppLocalizations.of(context)!.follow_button,
                      style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchUserController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? username;

  // Search users with partial matching (case-insensitive)
  Future<QuerySnapshot> searchUsers(String searchTerm) async {
    String lowerSearchTerm = searchTerm.toLowerCase();

    return FirebaseFirestore.instance
        .collection('users')
        .where('username_lowercase', isGreaterThanOrEqualTo: lowerSearchTerm)
        .where('username_lowercase', isLessThan: '${lowerSearchTerm}z')
        .get();
  }

  @override
  void dispose() {
    searchUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.search_user,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: searchUserController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search_hintext,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01,
                    color: cyberRose,
                    size: 22,
                  ),
                ),
              ),
              onChanged: (value) {
                username = value.trim();
                setState(() {});
              },
            ),
            const SizedBox(height: 40),
            if (username != null &&
                username!.isNotEmpty &&
                username!.length >= 2)
              FutureBuilder<QuerySnapshot>(
                future: searchUsers(username!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: cyberRose),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }

                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return Text(
                      AppLocalizations.of(context)!.no_user_found,
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              doc['username']
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                            ),
                          ),
                          title: Text(
                            doc['username'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          // subtitle: Text(
                          //   doc['email'] ?? 'No email',
                          //   style: Theme.of(context).textTheme.labelSmall,
                          // ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedMessage01,
                                  color: cyberRose,
                                ),
                                onPressed: () async {
                                  final currentUser =
                                      FirebaseAuth.instance.currentUser;
                                  if (currentUser == null) return;

                                  // Check if chat already exists
                                  final chatQuery = await FirebaseFirestore
                                      .instance
                                      .collection('chats')
                                      .where(
                                        'participants',
                                        arrayContains: currentUser.uid,
                                      )
                                      .get();

                                  String? chatId;
                                  for (var chatDoc in chatQuery.docs) {
                                    List participants = chatDoc['participants'];
                                    if (participants.contains(doc.id)) {
                                      chatId = chatDoc.id;
                                      break;
                                    }
                                  }

                                  if (chatId == null) {
                                    // Create new chat
                                    final newChat = await FirebaseFirestore
                                        .instance
                                        .collection('chats')
                                        .add({
                                          'participants': [
                                            currentUser.uid,
                                            doc.id,
                                          ],
                                          'lastMessage': '',
                                          'lastMessageTime': DateTime.now(),
                                        });
                                    chatId = newChat.id;
                                  }

                                  if (mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDetailPage(
                                          chatId: chatId!,
                                          otherUserId: doc.id,
                                          otherUsername: doc['username'],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              FollowButton(userDoc: doc),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
