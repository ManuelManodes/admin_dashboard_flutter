import 'package:flutter/material.dart';
import 'package:admin_dashboard/ui/shared/widgets/navbar_avatar.dart';
import 'package:admin_dashboard/ui/shared/widgets/notifications_indicator.dart';
import 'package:admin_dashboard/ui/shared/responsive_utils.dart';
import 'package:admin_dashboard/providers/sidemenu_provider.dart';

class TopHeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.getScreenWidth(context);

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Menu button for mobile
            if (screenWidth <= 700)
              IconButton(
                onPressed: () => SideMenuProvider.openMenu(),
                icon: Icon(Icons.menu, size: 24),
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),

            // Project identifier
            _buildProjectIdentifier(),

            SizedBox(width: 24),

            // Search bar
            if (screenWidth > 600) Expanded(flex: 2, child: _buildSearchBar()),

            Spacer(),

            // User info section
            _buildUserSection(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectIdentifier() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue.shade200, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.business_outlined, size: 16, color: Colors.blue.shade700),
          SizedBox(width: 6),
          Text(
            'Admin Dashboard',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      height: 36,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildUserSection(double screenWidth) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notifications
        NotificationsIndicator(),

        SizedBox(width: 12),

        // User info
        if (screenWidth > 768) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 6),
                Text(
                  'Usuario Admin',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
        ],

        // Avatar
        NavbarAvatar(),

        SizedBox(width: 8),
      ],
    );
  }
}
