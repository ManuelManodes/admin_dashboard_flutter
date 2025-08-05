import 'package:admin_dashboard/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/services/navigation_service.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  String? _token;
  AuthStatus authStatus = AuthStatus.checking;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() async {
    await isAuthenticated();
  }

  login(String email, String password) async {
    authStatus = AuthStatus.checking;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 1000));

    this._token = 'dummy_token.dfknveiorjssfeee';
    LocalStorage.prefs.setString('token', this._token!);
    authStatus = AuthStatus.authenticated;
    notifyListeners();

    // Limpiar el historial de navegación para evitar volver atrás al login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.navigateToAndClear('/dashboard');
    });
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = LocalStorage.prefs.getString('token');

      if (token == null) {
        authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      // Simular verificación del token
      await Future.delayed(Duration(milliseconds: 500));

      authStatus = AuthStatus.authenticated;
      this._token = token;
      notifyListeners();

      // Si está autenticado, limpiar historial al redirigir
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentContext = NavigationService.navigatorKey.currentContext;
        if (currentContext != null) {
          final currentRoute =
              ModalRoute.of(currentContext)?.settings.name ?? '/';

          if (currentRoute == '/' || currentRoute.startsWith('/auth')) {
            NavigationService.navigateToAndClear('/dashboard');
          }
        }
      });

      return true;
    } catch (e) {
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    // Primero cambiar el estado
    LocalStorage.prefs.remove('token');
    _token = null;
    authStatus = AuthStatus.unauthenticated;
    notifyListeners();

    // Luego navegar después de un frame y limpiar historial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.navigateToAndClear('/auth/login');
    });
  }

  String? get token => _token;
}
