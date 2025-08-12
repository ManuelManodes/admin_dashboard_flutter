import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/api/CafeApi.dart';
import 'package:admin_dashboard/services/notifications_service.dart';
import 'package:admin_dashboard/services/google_sign_in_service.dart';
import 'package:flutter/material.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  String? _token;
  AuthStatus authStatus = AuthStatus.checking;
  bool _isRegistering = false;

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

    // Navegar sin mostrar snackbar inmediatamente
    await Future.delayed(Duration(milliseconds: 100));
    NavigationService.navigateToAndClear('/dashboard');
  }

  // Nuevo método para login con Google
  Future<bool> signInWithGoogle() async {
    try {
      authStatus = AuthStatus.checking;
      notifyListeners();

      print('🚀 Iniciando login con Google...');

      // Usar método mock hasta configurar Client ID real
      final account = await GoogleSignInService.signInWithGoogleMock();

      if (account != null) {
        print('✅ Login exitoso: ${account.email}');

        // Obtener información del usuario
        this._token = 'google_token_${account.id}';
        LocalStorage.prefs.setString('token', this._token!);
        LocalStorage.prefs.setString('user_email', account.email);
        LocalStorage.prefs.setString('user_name', account.displayName);

        authStatus = AuthStatus.authenticated;
        notifyListeners();

        // Navegar al dashboard
        await Future.delayed(Duration(milliseconds: 100));
        NavigationService.navigateToAndClear('/dashboard');

        // Mostrar mensaje de éxito
        await Future.delayed(Duration(milliseconds: 500));
        _showDelayedNotification('Inicio de sesión exitoso con Google');

        return true;
      } else {
        print('❌ Login cancelado o falló');
        authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        _showDelayedNotification('Inicio de sesión cancelado');
        return false;
      }
    } catch (error) {
      print('❌ Error en login con Google: $error');
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      _showDelayedNotification('Error al iniciar sesión con Google');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    if (_isRegistering) {
      print('⚠️ Registro ya en progreso, ignorando...');
      return false;
    }

    _isRegistering = true;
    print('Formulario válido... register');
    print('$email === $password === $name');

    try {
      CafeApi.configureDio();

      print('🌐 Intentando conectar a: http://localhost:8080/api/usuarios');

      final requestData = {
        'nombre': name,
        'correo': email,
        'password': password,
      };

      print('📤 Datos enviados: $requestData');

      final data = await CafeApi.httpPost('/usuarios', requestData);

      print('✅ Response Data: $data');

      this._token =
          data['token'] ??
          'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
      LocalStorage.prefs.setString('token', this._token!);
      authStatus = AuthStatus.authenticated;
      notifyListeners();

      // Navegar primero, luego mostrar el snackbar
      NavigationService.navigateToAndClear('/dashboard');

      // Esperar a que la navegación se complete antes de mostrar el snackbar
      await Future.delayed(Duration(milliseconds: 500));
      _showDelayedNotification('Cuenta creada exitosamente');

      return true;
    } catch (e) {
      print('❌ Error en registro: $e');
      _showDelayedNotification('Error al crear la cuenta');
      return false;
    } finally {
      _isRegistering = false;
    }
  }

  // Método auxiliar para mostrar notificaciones de forma segura
  void _showDelayedNotification(String message) {
    Future.delayed(Duration(milliseconds: 500), () {
      try {
        NotificationsService.showSnackbar(message);
      } catch (e) {
        print('📢 Notification (fallback): $message');
      }
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

      // Navegar sin mostrar snackbar durante la inicialización
      await Future.delayed(Duration(milliseconds: 100));
      final currentContext = NavigationService.navigatorKey.currentContext;
      if (currentContext != null) {
        final currentRoute =
            ModalRoute.of(currentContext)?.settings.name ?? '/';
        print('🌐 Ruta actual: $currentRoute');

        if (currentRoute == '/' || currentRoute.startsWith('/auth')) {
          NavigationService.debugLocalStorage();
          final lastRoute = NavigationService.getLastRoute();
          final targetRoute = lastRoute ?? '/dashboard';
          print('🚀 Redirigiendo a: $targetRoute');
          NavigationService.navigateToAndClear(targetRoute);
        }
      }

      return true;
    } catch (e) {
      print('❌ Error de autenticación: $e');
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    this._token = null;
    this.authStatus = AuthStatus.unauthenticated;
    LocalStorage.prefs.remove('token');
    LocalStorage.prefs.remove('user_email');
    LocalStorage.prefs.remove('user_name');

    // Cerrar sesión de Google si está conectado
    await GoogleSignInService.signOut();

    NavigationService.clearLastRoute();
    notifyListeners();
  }

  String? get token => _token;
}
