import 'package:chatapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundStart.color,
              AppColors.backgroundEnd.color,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              const CircleAvatar(radius: 60, backgroundColor: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                'username',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '1,234 followers',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 20),
                  Text('|'),
                  SizedBox(width: 20),
                  Text(
                    '5,678 messages',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: AppColors.white.color,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.color,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: AppColors.primary.color,
                  ),
                  title: Text('Notification Settings'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: AppColors.white.color,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.color,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: AppColors.primary.color,
                  ),
                  title: Text('Account'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: AppColors.white.color,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.color,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    // Handle logout
                    // Later: Implement logout functionality
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout, color: AppColors.tagRed.color),
                    title: Text('Logout'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
