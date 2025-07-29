import 'package:admin_dashboard/ui/layouts/auth/widgets/background_custom.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          //Desktop
          _DesktopBody(),
          // Mobile

          // LinkBar
        ],
      ),
    );
  }
}

class _DesktopBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.red,
      child: Row(
        children: [
          // Background
          BackgroundCustom(),
          // View Container
          Container(width: 600, height: double.infinity, color: Colors.black),
        ],
      ),
    );
  }
}
