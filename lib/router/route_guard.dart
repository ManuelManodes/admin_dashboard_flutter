import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;
  final bool requireAuthentication;

  const RouteGuard._({
    Key? key,
    required this.child,
    required this.requireAuthentication,
  }) : super(key: key);

  static Widget requireAuth(Widget child) {
    return RouteGuard._(child: child, requireAuthentication: true);
  }

  static Widget requireGuest(Widget child) {
    return RouteGuard._(child: child, requireAuthentication: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Mientras está verificando, mostrar loading
        if (authProvider.authStatus == AuthStatus.checking) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Verificando autenticación...'),
              ],
            ),
          );
        }

        final isAuthenticated =
            authProvider.authStatus == AuthStatus.authenticated;

        if (requireAuthentication && !isAuthenticated) {
          // Necesita auth pero no está autenticado
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.navigateToAndClear('/auth/login');
          });
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Redirigiendo al login...'),
              ],
            ),
          );
        }

        if (!requireAuthentication && isAuthenticated) {
          // No necesita auth pero está autenticado
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Intentar ir a la última ruta guardada o dashboard por defecto
            final lastRoute = NavigationService.getLastRoute();
            final targetRoute = lastRoute ?? '/dashboard';
            NavigationService.navigateToAndClear(targetRoute);
          });
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Redirigiendo al dashboard...'),
              ],
            ),
          );
        }

        return child;
      },
    );
  }
}
