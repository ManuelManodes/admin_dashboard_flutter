import 'package:flutter/material.dart';

class NavbarAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        color: Colors.grey.shade100,
      ),
      child: ClipOval(
        child: Container(
          child: Icon(Icons.person, size: 20, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
