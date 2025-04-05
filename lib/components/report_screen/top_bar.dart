import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFFC7E7FB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF9CD8FD),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.person, color: Color(0xFF069DFD))
          ),
          Text(
            "Child's Report",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 18,
              color: Color(0xFF069DFD),
              fontWeight: FontWeight.bold
            )
          )
        ]
      )
    );
  }
}