import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthServicePure {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Registro con email y contraseña usando solo Firebase
  static Future<Map<String, dynamic>> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      // Crear usuario en Firebase Authentication
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user == null) {
        return {'ok': false, 'msg': 'Error al crear el usuario'};
      }

      // Actualizar el perfil del usuario
      await user.updateDisplayName(name);

      // Guardar información adicional en Firestore
      await _firestore.collection('usuarios').doc(user.uid).set({
        'uid': user.uid,
        'correo': email,
        'nombre': name,
        'fechaCreacion': FieldValue.serverTimestamp(),
        'activo': true,
      });

      // Obtener el token de Firebase
      final String? token = await user.getIdToken();
      return {
        'ok': true,
        'token': token,
        'usuario': {'uid': user.uid, 'correo': user.email, 'nombre': name},
      };
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Error de Firebase Auth: ${e.code} - ${e.message}');

      String mensaje = 'Error al crear la cuenta';
      switch (e.code) {
        case 'weak-password':
          mensaje = 'La contraseña es muy débil';
          break;
        case 'email-already-in-use':
          mensaje = 'El correo ya está registrado';
          break;
        case 'invalid-email':
          mensaje = 'El correo no es válido';
          break;
        default:
          mensaje = e.message ?? 'Error al crear la cuenta';
      }

      return {'ok': false, 'msg': mensaje};
    } catch (e) {
      debugPrint('❌ Error inesperado en registro: $e');
      return {'ok': false, 'msg': 'Error al crear la cuenta: ${e.toString()}'};
    }
  }

  /// Login con email y contraseña usando solo Firebase
  static Future<Map<String, dynamic>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Autenticar con Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user == null) {
        return {'ok': false, 'msg': 'Error en la autenticación'};
      }

      // Obtener información del usuario desde Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .get();

      Map<String, dynamic> userData = {};
      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
      } else {
        // Si no existe en Firestore, crear el documento
        userData = {
          'uid': user.uid,
          'correo': user.email,
          'nombre': user.displayName ?? '',
        };
        await _firestore.collection('usuarios').doc(user.uid).set({
          ...userData,
          'fechaCreacion': FieldValue.serverTimestamp(),
          'activo': true,
        });
      }

      // Obtener el token de Firebase
      final String? token = await user.getIdToken();

      debugPrint('✅ Login exitoso');
      return {'ok': true, 'token': token, 'usuario': userData};
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Error de Firebase Auth: ${e.code} - ${e.message}');

      String mensaje = 'Credenciales incorrectas';
      switch (e.code) {
        case 'user-not-found':
          mensaje = 'Usuario no encontrado';
          break;
        case 'wrong-password':
          mensaje = 'Contraseña incorrecta';
          break;
        case 'invalid-email':
          mensaje = 'El correo no es válido';
          break;
        case 'user-disabled':
          mensaje = 'La cuenta está deshabilitada';
          break;
        case 'too-many-requests':
          mensaje = 'Demasiados intentos. Inténtalo más tarde';
          break;
        default:
          mensaje = e.message ?? 'Error al iniciar sesión';
      }

      return {'ok': false, 'msg': mensaje};
    } catch (e) {
      debugPrint('❌ Error inesperado en login: $e');
      return {'ok': false, 'msg': 'Error al iniciar sesión: ${e.toString()}'};
    }
  }

  /// Validar token de Firebase
  static Future<Map<String, dynamic>> validateToken(String token) async {
    try {
      final User? user = _firebaseAuth.currentUser;

      if (user == null) {
        return {'ok': false, 'msg': 'No hay usuario autenticado'};
      }

      // Verificar que el token siga siendo válido
      final String? currentToken = await user.getIdToken(true);

      if (currentToken == null) {
        return {'ok': false, 'msg': 'Token inválido'};
      }

      // Obtener información del usuario desde Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .get();

      Map<String, dynamic> userData = {};
      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
      } else {
        userData = {
          'uid': user.uid,
          'correo': user.email,
          'nombre': user.displayName ?? '',
        };
      }

      return {'ok': true, 'usuario': userData};
    } catch (e) {
      debugPrint('❌ Error validando token: $e');
      return {'ok': false, 'msg': 'Token inválido'};
    }
  }

  /// Cerrar sesión
  static Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      debugPrint('✅ Sesión cerrada');
    } catch (e) {
      debugPrint('❌ Error cerrando sesión: $e');
    }
  }

  /// Método auxiliar para guardar usuario en Firestore
  static Future<void> _saveUserToFirestore(User user) async {
    try {
      await _firestore.collection('usuarios').doc(user.uid).set({
        'uid': user.uid,
        'correo': user.email,
        'nombre': user.displayName ?? 'Usuario Google',
        'proveedor': 'google',
        'fechaCreacion': FieldValue.serverTimestamp(),
        'activo': true,
      }, SetOptions(merge: true));
      debugPrint('✅ Usuario Google guardado en Firestore');
    } catch (e) {
      debugPrint('❌ Error guardando usuario en Firestore: $e');
    }
  }

  /// Inicio de sesión con Google
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Configurar el provider de Google
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Configurar scopes opcionales
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      UserCredential userCredential;

      if (kIsWeb) {
        // En web, usar signInWithPopup
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // En móvil, intentar con redirect
        await _firebaseAuth.signInWithRedirect(googleProvider);
        // Obtener el resultado después del redirect
        userCredential = await _firebaseAuth.getRedirectResult();

        // Si no hay resultado, significa que aún no se completó el redirect
        if (userCredential.user == null) {
          return {
            'success': false,
            'message': 'Inicio de sesión en proceso, espera a ser redirigido',
          };
        }
      }

      if (userCredential.user != null) {
        debugPrint('✅ Inicio de sesión con Google exitoso');

        // Guardar información del usuario en Firestore
        await _saveUserToFirestore(userCredential.user!);

        return {
          'success': true,
          'user': userCredential.user,
          'message': 'Inicio de sesión con Google exitoso',
        };
      } else {
        return {
          'success': false,
          'message': 'No se pudo obtener información del usuario',
        };
      }
    } catch (e) {
      debugPrint('❌ Error en inicio de sesión con Google: $e');

      String errorMessage = 'Error desconocido';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            errorMessage =
                'Ya existe una cuenta con este email usando otro método de inicio de sesión';
            break;
          case 'invalid-credential':
            errorMessage = 'Las credenciales de Google no son válidas';
            break;
          case 'user-disabled':
            errorMessage = 'Esta cuenta ha sido deshabilitada';
            break;
          case 'popup-closed-by-user':
            errorMessage = 'Inicio de sesión cancelado por el usuario';
            break;
          case 'popup-blocked':
            errorMessage = 'El popup fue bloqueado por el navegador';
            break;
          default:
            errorMessage = 'Error de autenticación: ${e.message}';
        }
      } else {
        errorMessage = 'Error: $e';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  /// Obtener usuario actual
  static User? get currentUser => _firebaseAuth.currentUser;

  /// Stream del estado de autenticación
  static Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
