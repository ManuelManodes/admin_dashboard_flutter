import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static GoogleSignIn? _googleSignIn;

  static GoogleSignIn get googleSignIn {
    if (_googleSignIn == null) {
      _googleSignIn = GoogleSignIn(
        // Client ID temporal para desarrollo (puedes usar uno de prueba)
        clientId:
            '1234567890-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
        // Configuración específica para web
        signInOption: SignInOption.standard,
      );
    }
    return _googleSignIn!;
  }

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      print('🔍 Intentando sign in con Google...');

      // Verificar si ya hay un usuario autenticado
      GoogleSignInAccount? currentUser = googleSignIn.currentUser;
      print('👤 Usuario actual: $currentUser');

      if (currentUser == null) {
        print('🚀 Iniciando proceso de sign in...');
        // Si no hay usuario, realizar sign in
        currentUser = await googleSignIn.signIn();
        print('✅ Sign in completado: $currentUser');
      }

      return currentUser;
    } catch (error) {
      print('❌ Error signing in with Google: $error');
      return null;
    }
  }

  // Método temporal para simular login sin configuración real
  static Future<MockGoogleAccount?> signInWithGoogleMock() async {
    try {
      print('🔄 Simulando login con Google...');

      // Simular proceso de autenticación
      await Future.delayed(Duration(milliseconds: 1500));

      // Retornar datos simulados
      return MockGoogleAccount(
        id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'usuario@gmail.com',
        displayName: 'Usuario de Prueba',
      );
    } catch (error) {
      print('❌ Error en mock sign in: $error');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  static Future<GoogleSignInAccount?> getCurrentUser() async {
    return googleSignIn.currentUser;
  }

  static bool get isSignedIn => googleSignIn.currentUser != null;
}

// Clase mock para simular GoogleSignInAccount
class MockGoogleAccount {
  final String id;
  final String email;
  final String displayName;

  MockGoogleAccount({
    required this.id,
    required this.email,
    required this.displayName,
  });
}
