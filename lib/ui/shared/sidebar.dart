import 'package:admin_dashboard/providers/sidemenu_provider.dart';
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
            onPressed: () => SideMenuProvider.closeMenu(),
          ),
          MenuItem(icon: Icons.settings, text: 'Settings', onPressed: () {}),
          MenuItem(
            icon: Icons.notifications,
            text: 'Notifications',
            onPressed: () {},
          ),
          MenuItem(
            icon: Icons.shopping_cart_checkout_outlined,
            text: 'Shop',
            onPressed: () {},
          ),
          MenuItem(icon: Icons.analytics, text: 'Analytics', onPressed: () {}),
          MenuItem(icon: Icons.category, text: 'Categories', onPressed: () {}),

          SizedBox(height: 30),

          TextSeparator(text: 'UI Elements'),

          MenuItem(
            icon: Icons.list_alt_outlined,
            text: 'Icons',
            onPressed: () {},
          ),
          MenuItem(
            icon: Icons.mark_email_read_outlined,
            text: 'Marketing',
            onPressed: () {},
          ),
          MenuItem(
            icon: Icons.note_add_outlined,
            text: 'Campaigns',
            onPressed: () {},
          ),
          MenuItem(
            icon: Icons.post_add_outlined,
            text: 'Black',
            onPressed: () {},
          ),
          MenuItem(icon: Icons.logout, text: 'Logout', onPressed: () {}),
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
