import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zuvo/l10n/app_localizations.dart';

class Greeting extends StatefulWidget {
  const Greeting({super.key});

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> {
  User? user = FirebaseAuth.instance.currentUser;

  late String greeting;
  late String currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Update time every minute (not every frame!)
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateTime();
    });
  }

  void _updateGreeting() {
    if (user == null) {
      greeting = 'Welcome!';
      return;
    }

    var hour = DateTime.now().hour;
    String userName = user!.displayName ?? 'User';

    if (hour >= 6 && hour < 12) {
      greeting =
          '${AppLocalizations.of(context)!.morining_greetings}, $userName ! 🌅';
    } else if (hour >= 12 && hour < 18) {
      greeting =
          '${AppLocalizations.of(context)!.afternoon_greetings}, $userName ! ☀️';
    } else {
      greeting =
          '${AppLocalizations.of(context)!.evening_greetings}, $userName ! 🌙';
    }
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        var now = DateTime.now();
        currentTime =
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Call _updateGreeting here (after inherited widgets are available)
    _updateGreeting();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              if (user?.photoURL != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoURL!),
                  radius: 50,
                ),
              const SizedBox(width: 4),
              Text(
                greeting,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // Text(
          //   'It\'s $currentTime',
          //   style: Theme.of(context).textTheme.bodyMedium,
          // ),
        ],
      ),
    );
  }
}
