import 'package:chatapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MainAppTile extends StatelessWidget {
  const MainAppTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: AppColors.white.color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.color,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 0), // Shadow is all around
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          title: Row(
            children: [
              Text("User Name", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tagGreen.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Tag",
                  style: TextStyle(
                    color: AppColors.tagGreen.color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          trailing: Text("Time"),
          subtitle: Text("Last message content"),
          leading: CircleAvatar(radius: 25),
        ),
      ),
    );
  }
}
