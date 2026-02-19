import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SizedBox(
        width: 380,
        child: SearchBar(
          hintText: 'Search Conversations',
          hintStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.bold, color: Color(0xff9fa6b2)),
          ),
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          elevation: WidgetStatePropertyAll(0.0),
          leading: const Icon(Icons.search, color: Color(0xff8379f5)),
          padding: WidgetStatePropertyAll(EdgeInsets.only(left: 16)),
        ),
      ),
    );
  }
}
