import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/notifications_service.dart';
import '../services/firebase_auth_service_pure.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> login(String email, String password) async {
    authStatus = AuthStatus.checking;
    notifyListeners();

    try {
      // Usar FirebaseAuthServicePure para login
      final data = await firebase_auth
          .FirebaseAuthServicePure.signInWithEmailAndPassword(email, password);

      // Verificar si el login fue exitoso
      if (data['ok'] == true && data['token'] != null) {
        _token = data['token'];
        LocalStorage.prefs.setString('token', _token!);

        // Guardar información del usuario si viene en la respuesta
        if (data['usuario'] != null) {
          final usuario = data['usuario'];
          LocalStorage.prefs.setString(
            'user_email',
            usuario['correo'] ?? email,
          );
          LocalStorage.prefs.setString('user_name', usuario['nombre'] ?? '');
          LocalStorage.prefs.setString('user_id', usuario['uid'] ?? '');
        }

        authStatus = AuthStatus.authenticated;
        notifyListeners();

        // Navegar al dashboard
        await Future.delayed(const Duration(milliseconds: 100));
        NavigationService.navigateToAndClear('/dashboard');

        // Mostrar mensaje de éxito
        await Future.delayed(const Duration(milliseconds: 500));
        _showDelayedNotification('Inicio de sesión exitoso');
      } else {
        // Login falló - credenciales incorrectas
        authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        _showDelayedNotification(data['msg'] ?? 'Credenciales incorrectas');
      }
    } catch (e) {
      debugPrint('❌ Error en login: $e');
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();

      // Mensaje de error más específico
      String errorMessage = 'Error al iniciar sesión';
      if (e.toString().contains('401')) {
        errorMessage = 'Credenciales incorrectas';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Usuario no encontrado';
      } else if (e.toString().contains('connection')) {
        errorMessage = 'Error de conexión con el servidor';
      }

      _showDelayedNotification(errorMessage);
    }
  }

  // Método para login con Google usando Firebase Auth (PENDIENTE DE IMPLEMENTAR)
  Future<bool> signInWithGoogle() async {
    try {
      authStatus = AuthStatus.checking;
      notifyListeners();

      debugPrint('🚀 Google Sign-In no implementado aún...');

      // TODO: Implementar Google Sign-In cuando esté configurado
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      _showDelayedNotification('Google Sign-In no disponible aún');
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Error de Firebase Auth: ${e.code} - ${e.message}');
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();

      String errorMessage = 'Error al iniciar sesión con Google';
      switch (e.code) {
        case 'popup-closed-by-user':
          errorMessage = 'Inicio de sesión cancelado';
          break;
        case 'network-request-failed':
          errorMessage = 'Error de conexión';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }

      _showDelayedNotification(errorMessage);
      return false;
    } catch (error) {
      debugPrint('❌ Error en login con Google: $error');
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      _showDelayedNotification('Error al iniciar sesión con Google');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    if (_isRegistering) {
      return false;
    }

    _isRegistering = true;

    try {
      // Usar FirebaseAuthServicePure para registro
      final data =
          await firebase_auth
              .FirebaseAuthServicePure.registerWithEmailAndPassword(
            email,
            password,
            name,
          );

      // Verificar si el registro fue exitoso
      if (data['ok'] == true && data['token'] != null) {
        _token = data['token'];
        LocalStorage.prefs.setString('token', _token!);

        // Guardar información del usuario si viene en la respuesta
        if (data['usuario'] != null) {
          final usuario = data['usuario'];
          LocalStorage.prefs.setString(
            'user_email',
            usuario['correo'] ?? email,
          );
          LocalStorage.prefs.setString('user_name', usuario['nombre'] ?? name);
          LocalStorage.prefs.setString('user_id', usuario['uid'] ?? '');
        }

        authStatus = AuthStatus.authenticated;
        notifyListeners();

        // Navegar primero, luego mostrar el snackbar
        NavigationService.navigateToAndClear('/dashboard');

        // Esperar a que la navegación se complete antes de mostrar el snackbar
        await Future.delayed(const Duration(milliseconds: 500));
        _showDelayedNotification('Cuenta creada exitosamente');

        return true;
      } else {
        // Registro falló
        authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        _showDelayedNotification(data['msg'] ?? 'Error al crear la cuenta');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error en registro: $e');
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();

      // Mensaje de error más específico
      String errorMessage = 'Error al crear la cuenta';
      if (e.toString().contains('400')) {
        errorMessage = 'El correo ya está registrado';
      } else if (e.toString().contains('connection')) {
        errorMessage = 'Error de conexión con el servidor';
      }

      _showDelayedNotification(errorMessage);
      return false;
    } finally {
      _isRegistering = false;
    }
  }

  // Método auxiliar para mostrar notificaciones de forma segura
  void _showDelayedNotification(String message) {
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        NotificationsService.showSnackbar(message);
      } catch (e) {
        debugPrint('📢 Notification (fallback): $message');
      }
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

      // Validar token con FirebaseAuthServicePure
      final data = await firebase_auth.FirebaseAuthServicePure.validateToken(
        token,
      );

      if (data['ok'] == true && data['usuario'] != null) {
        _token = token;
        final usuario = data['usuario'];

        // Actualizar información del usuario en localStorage
        LocalStorage.prefs.setString('user_email', usuario['correo'] ?? '');
        LocalStorage.prefs.setString('user_name', usuario['nombre'] ?? '');
        LocalStorage.prefs.setString('user_id', usuario['uid'] ?? '');

        authStatus = AuthStatus.authenticated;
        notifyListeners();

        return true;
      } else {
        // Token inválido o expirado
        authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error de autenticación: $e');
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    _token = null;
    authStatus = AuthStatus.unauthenticated;
    LocalStorage.prefs.remove('token');
    LocalStorage.prefs.remove('user_email');
    LocalStorage.prefs.remove('user_name');
    LocalStorage.prefs.remove('user_id');

    // Cerrar sesión de Firebase y Google
    await firebase_auth.FirebaseAuthServicePure.signOut();

    NavigationService.clearLastRoute();
    notifyListeners();
  }

  /// Inicio de sesión con Google
  Future<bool> loginWithGoogle() async {
    authStatus = AuthStatus.checking;
    notifyListeners();

    try {
      final result =
          await firebase_auth.FirebaseAuthServicePure.signInWithGoogle();

      if (result['success'] == true) {
        final User? user = result['user'];
        if (user == null) {
          authStatus = AuthStatus.unauthenticated;
          notifyListeners();
          NotificationsService.showSnackbar(
            'Error: No se pudo obtener la información del usuario',
          );
          return false;
        }

        try {
          _token = await user.getIdToken();
          debugPrint('🎫 Token obtenido: ${_token?.substring(0, 20)}...');
        } catch (e) {
          debugPrint('❌ Error obteniendo token: $e');
          authStatus = AuthStatus.unauthenticated;
          notifyListeners();
          NotificationsService.showSnackbar(
            'Error: No se pudo obtener el token de autenticación',
          );
          return false;
        }

        if (_token == null) {
          debugPrint('❌ Token es null');
          authStatus = AuthStatus.unauthenticated;
          notifyListeners();
          NotificationsService.showSnackbar(
            'Error: Token de autenticación inválido',
          );
          return false;
        }

        // Guardar el token y user ID
        await LocalStorage.prefs.setString('token', _token!);
        await LocalStorage.prefs.setString('user_id', user.uid);

        authStatus = AuthStatus.authenticated;
        notifyListeners();

        NotificationsService.showSnackbar(
          '¡Bienvenido ${user.displayName ?? 'Usuario'}!',
        );

        // Navegar al dashboard con un ligero delay para asegurar que el widget tree esté listo
        Future.delayed(Duration(milliseconds: 100), () {
          try {
            NavigationService.replaceTo('/dashboard');
            debugPrint('✅ Navegación exitosa al dashboard');
          } catch (navError) {
            debugPrint('❌ Error en navegación: $navError');
            // Intentar navegación alternativa
            Future.delayed(Duration(milliseconds: 500), () {
              try {
                NavigationService.navigateTo('/dashboard');
                debugPrint('✅ Navegación alternativa exitosa');
              } catch (navError2) {
                debugPrint('❌ Error en navegación alternativa: $navError2');
                // Como último recurso, simplemente recargar la página en web
                debugPrint('🔄 Recargando página como último recurso');
              }
            });
          }
        });

        return true;
      } else {
        debugPrint('❌ Login con Google falló: ${result['message']}');
        authStatus = AuthStatus.unauthenticated;
        notifyListeners();

        NotificationsService.showSnackbar(
          'Error: ${result['message'] ?? 'Error en inicio de sesión con Google'}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error en login con Google: $e');
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      NotificationsService.showSnackbar(
        'Error inesperado en inicio de sesión con Google',
      );
      return false;
    }
  }

  String? get token => _token;
}
