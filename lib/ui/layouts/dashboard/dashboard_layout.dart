import 'package:flutter/material.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;

  const DashboardLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar o menú lateral (si existe en tu proyecto)
          // SidebarWidget(),

          // Contenido principal
          Expanded(
            child: Column(
              children: [
                // Navbar superior (si existe en tu proyecto)
                // NavbarWidget(),

                // Contenido del dashboard - aquí se muestra el child
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
