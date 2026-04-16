import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:zuvo/constant/app_colors.dart';
import 'package:zuvo/l10n/app_localizations.dart';
import 'package:zuvo/providers/locale_provider.dart';
import 'package:zuvo/providers/theme_provider.dart';
import 'package:zuvo/util/image_post.dart';
import 'package:zuvo/util/text_post.dart';
import 'package:zuvo/util/toast_notification.dart';
import 'package:zuvo/views/auth/sign_in_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      ToastNotification.showSuccess(
        context,
        title: AppLocalizations.of(context)!.success_title,
        description: AppLocalizations.of(context)!.signout_successfully,
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignInPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return IconButton(
              onPressed: () {
                final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
                themeProvider.setThemeMode(
                  isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
              },
              icon: HugeIcon(
                icon: themeProvider.themeMode == ThemeMode.dark
                    ? HugeIcons.strokeRoundedSun01
                    : HugeIcons.strokeRoundedMoon01,
                size: 24,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            );
          },
        ),
        actions: [
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        localeProvider.setLocale(Locale('en'));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: localeProvider.locale.languageCode == 'en'
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'EN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: localeProvider.locale.languageCode == 'en'
                                ? trueWhite
                                : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        localeProvider.setLocale(Locale('fr'));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: localeProvider.locale.languageCode == 'fr'
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'FR',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: localeProvider.locale.languageCode == 'fr'
                                ? trueWhite
                                : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          IconButton(
            onPressed: _logout,
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedLogout02,
              color: cyberRose,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: cyberRose,
                      child: Text(
                        (user?.displayName ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.displayName ??
                          AppLocalizations.of(context)!.unknown_user,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? AppLocalizations.of(context)!.no_email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Stats Section
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  var userData = snapshot.data!.data() as Map?;
                  var followers = userData?['followers_count'] ?? 0;
                  var following = userData?['following_count'] ?? 0;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: user?.uid)
                            .snapshots(),
                        builder: (context, postSnapshot) {
                          int postCount = postSnapshot.data?.docs.length ?? 0;
                          return _buildStatColumn(
                            context,
                            AppLocalizations.of(context)!.my_posts,
                            postCount.toString(),
                          );
                        },
                      ),
                      _buildStatColumn(
                        context,
                        AppLocalizations.of(context)!.followers,
                        followers.toString(),
                      ),
                      _buildStatColumn(
                        context,
                        AppLocalizations.of(context)!.following,
                        following.toString(),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // My Posts Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.my_posts,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: user?.uid)
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

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedDoc01,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.no_posted_yet,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  // Sort locally to avoid index requirement
                  var docs = snapshot.data!.docs;
                  docs.sort((a, b) {
                    var aTime = (a.data() as Map)['time'] as Timestamp?;
                    var bTime = (b.data() as Map)['time'] as Timestamp?;
                    if (aTime == null || bTime == null) return 0;
                    return bTime.compareTo(aTime); // Descending
                  });

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var postDoc = docs[index];
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

  Widget _buildStatColumn(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: cyberRose,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
