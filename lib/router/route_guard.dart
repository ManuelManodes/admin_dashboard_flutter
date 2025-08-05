import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteGuard {
  static Widget requireAuth(Widget child) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.authStatus == AuthStatus.checking) {
          return Center(child: CircularProgressIndicator());
        }

        if (authProvider.authStatus == AuthStatus.unauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.navigateToAndClear('/auth/login');
          });
          return Center(child: CircularProgressIndicator());
        }

        return child;
      },
    );
  }

  static Widget requireGuest(Widget child) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.authStatus == AuthStatus.checking) {
          return Center(child: CircularProgressIndicator());
        }

        if (authProvider.authStatus == AuthStatus.authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.navigateToAndClear('/dashboard');
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
