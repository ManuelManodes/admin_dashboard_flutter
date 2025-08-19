import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/navigation_service.dart';

class HorizontalNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _buildNavItem(
              'Dashboard',
              Icons.dashboard_outlined,
              Flurorouter.dashboardRoute,
              sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
            ),
            _buildNavItem(
              'Analytics',
              Icons.analytics_outlined,
              '/dashboard/analytics',
              sideMenuProvider.currentPage == '/dashboard/analytics',
            ),
            _buildNavItem(
              'Settings',
              Icons.settings_outlined,
              '/dashboard/settings',
              sideMenuProvider.currentPage == '/dashboard/settings',
            ),
            _buildNavItem(
              'Users',
              Icons.people_outline,
              '/dashboard/users',
              sideMenuProvider.currentPage == '/dashboard/users',
            ),
            _buildNavItem(
              'Agendamiento',
              Icons.calendar_today_outlined,
              Flurorouter.schedulingRoute,
              sideMenuProvider.currentPage == Flurorouter.schedulingRoute,
            ),
            _buildNavItem(
              'Icons',
              Icons.list_alt_outlined,
              Flurorouter.iconsRoute,
              sideMenuProvider.currentPage == Flurorouter.iconsRoute,
            ),
            _buildNavItem(
              'Reports',
              Icons.assessment_outlined,
              '/dashboard/reports',
              sideMenuProvider.currentPage == '/dashboard/reports',
            ),
            _buildNavItem(
              'Marketing',
              Icons.mark_email_read_outlined,
              '/dashboard/marketing',
              sideMenuProvider.currentPage == '/dashboard/marketing',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String title,
    IconData icon,
    String route,
    bool isActive,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: 32),
      child: InkWell(
        onTap: () {
          NavigationService.navigateTo(route);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive ? Colors.blue.shade50 : Colors.transparent,
            border: isActive
                ? Border.all(color: Colors.blue.shade300, width: 1)
                : Border.all(color: Colors.transparent, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? Colors.blue.shade700 : Colors.grey.shade600,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? Colors.blue.shade700 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
