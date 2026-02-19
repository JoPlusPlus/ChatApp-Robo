import 'package:chatapp/utils/app_colors.dart';
import 'package:chatapp/Widgets/main_app_tile.dart';
import 'package:chatapp/Widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Search bar
          SearchBarWidget(),
          const SizedBox(height: 5),
          HomeScreenButtonRow(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(top: 20),
              itemCount: 20,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20);
              },
              itemBuilder: (context, index) {
                return Center(child: MainAppTile());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenButtonRow extends StatefulWidget {
  const HomeScreenButtonRow({super.key});

  @override
  State<HomeScreenButtonRow> createState() => _HomeScreenButtonRowState();
}

class _HomeScreenButtonRowState extends State<HomeScreenButtonRow> {
  bool _isActiveButtonSelected = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Conversations list
        Column(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isActiveButtonSelected = true;
                });
              },
              child: Text(
                "ACTIVE",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isActiveButtonSelected
                      ? AppColors.primary.color
                      : AppColors.grey.color,
                ),
              ),
            ),
            if (_isActiveButtonSelected) SelectedIndicator(),
          ],
        ),
        const SizedBox(width: 150),
        Column(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isActiveButtonSelected = false;
                });
              },
              child: Text(
                "ALL",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: !_isActiveButtonSelected
                      ? AppColors.primary.color
                      : AppColors.grey.color,
                ),
              ),
            ),
            if (!_isActiveButtonSelected) SelectedIndicator(),
          ],
        ),
      ],
    );
  }
}

class SelectedIndicator extends StatelessWidget {
  const SelectedIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.primary.color,
        shape: BoxShape.circle,
      ),
    );
  }
}
