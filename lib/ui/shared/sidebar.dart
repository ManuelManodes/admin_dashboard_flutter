import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/ui/shared/widgets/logo.dart';
import 'package:admin_dashboard/ui/shared/widgets/menu_item.dart';
import 'package:admin_dashboard/ui/shared/widgets/text_separator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/providers/auth_provider.dart';

class Sidebar extends StatelessWidget {
  void navigateTo(String routeName) {
    NavigationService.navigateTo(routeName);
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);

    return Container(
      width: 250,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Logo(),
          SizedBox(height: 50),
          TextSeparator(text: 'Main'),

          MenuItem(
            isActive:
                sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
            text: 'Dashboard',
            icon: Icons.compass_calibration_outlined,
            onPressed: () => navigateTo(Flurorouter.dashboardRoute),
          ),
          MenuItem(icon: Icons.settings, text: 'Settings', onPressed: () => {}),
          MenuItem(
            icon: Icons.notifications,
            text: 'Notifications',
            onPressed: () => {},
          ),
          MenuItem(
            icon: Icons.shopping_cart_checkout_outlined,
            text: 'Shop',
            onPressed: () => {},
          ),
          MenuItem(
            icon: Icons.analytics,
            text: 'Analytics',
            onPressed: () => {},
          ),
          MenuItem(
            icon: Icons.category,
            text: 'Categories',
            onPressed: () => {},
          ),

          SizedBox(height: 30),

          TextSeparator(text: 'UI Elements'),

          MenuItem(
            isActive: sideMenuProvider.currentPage == Flurorouter.iconsRoute,
            icon: Icons.list_alt_outlined,
            text: 'Icons',
            onPressed: () => navigateTo(Flurorouter.iconsRoute),
          ),
          MenuItem(
            icon: Icons.mark_email_read_outlined,
            text: 'Marketing',
            onPressed: () => {},
          ),
          MenuItem(
            icon: Icons.note_add_outlined,
            text: 'Campaigns',
            onPressed: () => SideMenuProvider.closeMenu(),
          ),

          SizedBox(height: 30),

          TextSeparator(text: 'Exit'),

          MenuItem(
            isActive: sideMenuProvider.currentPage == Flurorouter.blankRoute,
            icon: Icons.post_add_outlined,
            text: 'Blank',
            onPressed: () => navigateTo(Flurorouter.blankRoute),
          ),
          MenuItem(
            icon: Icons.logout,
            text: 'Logout',
            onPressed: () {
              // Implementar logout
              Provider.of<AuthProvider>(context, listen: false).logout();
              NavigationService.navigateToAndClear('/auth/login');
            },
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
