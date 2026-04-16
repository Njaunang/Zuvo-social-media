import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zuvo/constant/app_colors.dart';
import 'package:zuvo/l10n/app_localizations.dart';
import 'package:zuvo/views/home/home_page.dart';
import 'package:zuvo/views/home/search_page.dart';
import 'package:zuvo/views/messages/chat_page.dart';
import 'package:zuvo/views/calls/calls_page.dart';
import 'package:zuvo/views/profile/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const ChatPage(),
    const CallsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: cyberRose,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome02,
              size: 24,
              color: _currentIndex == 0 ? cyberRose : Colors.grey,
            ),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch02,
              size: 24,
              color: _currentIndex == 1 ? cyberRose : Colors.grey,
            ),
            label: AppLocalizations.of(context)!.search,
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedMessage02,
              size: 24,
              color: _currentIndex == 2 ? cyberRose : Colors.grey,
            ),
            label: AppLocalizations.of(context)!.messages,
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedCall02,
              size: 24,
              color: _currentIndex == 3 ? cyberRose : Colors.grey,
            ),
            label: AppLocalizations.of(context)!.calls,
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              size: 24,
              color: _currentIndex == 4 ? cyberRose : Colors.grey,
            ),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}
