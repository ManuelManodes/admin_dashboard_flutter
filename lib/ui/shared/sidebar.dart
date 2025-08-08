import 'package:admin_dashboard/ui/shared/widgets/logo.dart';
import 'package:admin_dashboard/ui/shared/widgets/menu_item.dart';
import 'package:admin_dashboard/ui/shared/widgets/text_separator.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Logo(),
          SizedBox(height: 50),
          TextSeparator(text: 'main'),

          MenuItem(
            icon: Icons.compass_calibration_outlined,
            text: 'Dashboard',
            onPressed: () => print('Dashboard pressed'),
          ),
          MenuItem(
            icon: Icons.settings,
            text: 'Settings',
            onPressed: () => print('Settings pressed'),
          ),
          MenuItem(
            icon: Icons.notifications,
            text: 'Notifications',
            onPressed: () => print('Notifications pressed'),
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xff092044), Color(0xff043478)],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
