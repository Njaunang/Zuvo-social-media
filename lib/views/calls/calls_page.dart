import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zuvo/constant/app_colors.dart';
import 'package:zuvo/l10n/app_localizations.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.calls,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          bottom: TabBar(
            onTap: (index) {
              setState(() {});
            },
            tabs: [
              Tab(text: AppLocalizations.of(context)!.voice),
              Tab(text: AppLocalizations.of(context)!.video),
              Tab(text: AppLocalizations.of(context)!.group_call),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVoiceCallTab(),
            _buildVideoCallTab(),
            _buildGroupCallTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceCallTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations.of(
              context,
            )!.select_a_contact_to_start_a_voice_call,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(cyberRose),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.no_users_available),
                );
              }

              var users = snapshot.data!.docs
                  .where((doc) => (doc.data() as Map)['uid'] != user?.uid)
                  .toList();

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var userData = users[index].data() as Map;
                  var username =
                      userData['username'] ??
                      AppLocalizations.of(context)!.user;
                  var uid = userData['uid'] ?? users[index].id;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cyberRose,
                      child: Text(
                        username[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(username),
                    trailing: IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCall02,
                        color: cyberRose,
                      ),
                      onPressed: () {
                        _startVoiceCall(uid, username);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCallTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations.of(
              context,
            )!.select_a_contact_to_start_a_voice_call,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(cyberRose),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.no_users_available),
                );
              }

              var users = snapshot.data!.docs
                  .where((doc) => (doc.data() as Map)['uid'] != user?.uid)
                  .toList();

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var userData = users[index].data() as Map;
                  var username =
                      userData['username'] ??
                      AppLocalizations.of(context)!.user;
                  var uid = userData['uid'] ?? users[index].id;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cyberRose,
                      child: Text(
                        username[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(username),
                    trailing: IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedVideoReplay,
                        color: cyberRose,
                      ),
                      onPressed: () {
                        _startVideoCall(uid, username);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCallTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedUser03,
          size: 64,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.start_a_group_call,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _startGroupCall,
          style: ElevatedButton.styleFrom(
            backgroundColor: cyberRose,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: Text(
            AppLocalizations.of(context)!.create_group_call,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _startVoiceCall(String recipientId, String recipientName) {
    // TODO: Replace with your ZegoCloud app ID and app sign
    const appID = 1060001019;
    const appSign = 'YOUR_APP_SIGN_HERE';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZegoUIKitPrebuiltCall(
          appID: appID,
          appSign: appSign,
          userID: user?.uid ?? '',
          userName: user?.displayName ?? AppLocalizations.of(context)!.user,
          callID: 'voice_${user?.uid}_$recipientId',
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
        ),
      ),
    );
  }

  void _startVideoCall(String recipientId, String recipientName) {
    // TODO: Replace with your ZegoCloud app ID and app sign
    const appID = 1060001019;
    const appSign = 'YOUR_APP_SIGN_HERE';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZegoUIKitPrebuiltCall(
          appID: appID,
          appSign: appSign,
          userID: user?.uid ?? '',
          userName: user?.displayName ?? AppLocalizations.of(context)!.user,
          callID: 'video_${user?.uid}_$recipientId',
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        ),
      ),
    );
  }

  void _startGroupCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.create_group_call),
        content: Text(AppLocalizations.of(context)!.group_call_come_soon),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
