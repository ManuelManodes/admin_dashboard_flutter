import 'package:flutter/material.dart';
import 'package:admin_dashboard/ui/shared/new_navbar.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;

  const DashboardLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDF1F2),
      body: Column(
        children: [
          NewNavBar(),
          Expanded(
            child: Padding(padding: const EdgeInsets.all(0), child: child),
          ),
        ],
      ),
    );
  }
}
