import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/ui/shared/navbar.dart';
import 'package:admin_dashboard/ui/shared/sidebar.dart';
import 'package:admin_dashboard/ui/shared/responsive_utils.dart';
import 'package:flutter/material.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;

  const DashboardLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SideMenuProvider.menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEDF1F2),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = ResponsiveUtils.getScreenWidth(context);

          return Stack(
            children: [
              Row(
                children: [
                  if (screenWidth >= 700) Sidebar(),

                  Expanded(
                    child: Column(
                      children: [
                        NavBar(),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.getResponsivePadding(
                                context,
                              ),
                              vertical: ResponsiveUtils.getResponsivePadding(
                                context,
                              ),
                            ),
                            child: widget.child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (screenWidth < 700)
                AnimatedBuilder(
                  animation: SideMenuProvider.menuController,
                  builder: (context, _) => Stack(
                    children: [
                      if (SideMenuProvider.isOpen)
                        Opacity(
                          opacity: SideMenuProvider.opacity.value,
                          child: GestureDetector(
                            onTap: () => SideMenuProvider.closeMenu(),
                            child: Container(
                              width: screenWidth,
                              height: constraints.maxHeight,
                              color: Colors.black26,
                            ),
                          ),
                        ),

                      // Overlay de fondo
                      if (SideMenuProvider.menuController.value > 0)
                        GestureDetector(
                          onTap: () => SideMenuProvider.closeMenu(),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black.withValues(
                              alpha:
                                  0.5 * SideMenuProvider.menuController.value,
                            ),
                          ),
                        ),
                      // Sidebar
                      Transform.translate(
                        offset: Offset(SideMenuProvider.movement.value, 0),
                        child: Sidebar(),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
