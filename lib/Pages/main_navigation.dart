import 'package:chatapp/Pages/home_page.dart';
import 'package:chatapp/utils/app_colors.dart';
import 'package:chatapp/Pages/profile_screen.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart.color,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Center(
                child: Text(
                  _selectedIndex == 0 ? 'Message' : 'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary.color,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.color,
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline_outlined, size: 25),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 25),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: AppColors.white.color,
            selectedIconTheme: IconThemeData(
              color: AppColors.primaryLight.color,
            ),
            unselectedIconTheme: IconThemeData(color: AppColors.grey.color),
            selectedItemColor: AppColors.primaryLight.color,
            unselectedItemColor: AppColors.grey.color,
          ),
        ),
      ),
    );
  }
}
