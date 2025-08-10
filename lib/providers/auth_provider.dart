import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:flutter/material.dart';

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
      print('🔒 Verificando autenticación, token: $token');

      if (token == null) {
        authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        print('❌ No autenticado: token nulo');
        return false;
      }

      // Simular verificación del token
      await Future.delayed(Duration(milliseconds: 500));

      authStatus = AuthStatus.authenticated;
      this._token = token;
      notifyListeners();
      print('✅ Autenticado con éxito');

      // Si está autenticado, redirigir a la última ruta o dashboard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentContext = NavigationService.navigatorKey.currentContext;
        if (currentContext != null) {
          final currentRoute =
              ModalRoute.of(currentContext)?.settings.name ?? '/';
          print('🌐 Ruta actual: $currentRoute');

          if (currentRoute == '/' || currentRoute.startsWith('/auth')) {
            // DEBUG: Verificar LocalStorage antes de decidir
            NavigationService.debugLocalStorage();

            // Usar la última ruta guardada o dashboard por defecto
            final lastRoute = NavigationService.getLastRoute();
            final targetRoute = lastRoute ?? '/dashboard';
            print('🚀 Redirigiendo a: $targetRoute');
            NavigationService.navigateToAndClear(targetRoute);
          }
        }
      });

      return true;
    } catch (e) {
      print('❌ Error de autenticación: $e');
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    this._token = null;
    this.authStatus = AuthStatus.unauthenticated;
    LocalStorage.prefs.remove('token');

    // Limpiar la última ruta guardada
    NavigationService.clearLastRoute();

    notifyListeners();
  }

  String? get token => _token;
}
