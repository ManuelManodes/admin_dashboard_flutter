import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/ui/layouts/auth/widgets/search_text.dart';
import 'package:admin_dashboard/ui/shared/widgets/navbar_avatar.dart';
import 'package:admin_dashboard/ui/shared/widgets/notifications_indicator.dart';
import 'package:admin_dashboard/ui/shared/responsive_utils.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.getScreenWidth(context);

    return Container(
      width: double.infinity,
      height: 50,
      decoration: buildBoxDecoration(),
      child: Row(
        children: [
          if (screenWidth <= 700)
            IconButton(
              onPressed: () => SideMenuProvider.openMenu(),
              icon: Icon(Icons.menu_sharp),
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  return Colors.transparent; // Quita todos los efectos
                }),
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ),
          SizedBox(width: 5),

          if (screenWidth > 390)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: SearchText(),
            ),

          Spacer(),

          NotificationsIndicator(),
          SizedBox(width: 10),
          NavbarAvatar(),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.grey.withOpacity(0.1),
  );
}
