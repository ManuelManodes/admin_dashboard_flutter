import 'package:admin_dashboard/services/notifications_service.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/ui/layouts/auth/auth_layout.dart';
import 'package:admin_dashboard/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:admin_dashboard/ui/layouts/splash/splash_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalStorage.configurePrefs();
  NavigationService.debugLocalStorage();

  // Detector de cambios en la URL para web
  _setupUrlChangeListener();

  Flurorouter.configureRoutes();
  runApp(AppState());
}

// Función para detectar cambios en la URL y guardarlos
void _setupUrlChangeListener() {
  // Captura la URL inicial
  final location = web.window.location;
  final path = location.hash.isNotEmpty ? location.hash.substring(1) : '';

  if (path.isNotEmpty && path.startsWith('/dashboard')) {
    LocalStorage.prefs.setString('lastRoute', path);
  }

  // Escuchar cambios futuros en la URL
  web.window.addEventListener(
    'hashchange',
    ((web.Event event) {
      final newLocation = web.window.location;
      final newPath = newLocation.hash.isNotEmpty
          ? newLocation.hash.substring(1)
          : '';

      if (newPath.isNotEmpty && newPath.startsWith('/dashboard')) {
        LocalStorage.prefs.setString('lastRoute', newPath);
      }
    }).toJS,
  );
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => SideMenuProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: NotificationsService.scaffoldMessengerKey,
      builder: (_, child) {
        final authProvider = Provider.of<AuthProvider>(context);

        // Solo mostrar splash cuando está checking
        if (authProvider.authStatus == AuthStatus.checking) {
          return SplashLayout();
        }

        // Lógica simplificada: solo usar layout basado en autenticación
        return _buildLayoutWrapper(authProvider, child!);
      },
    );
  }

  Widget _buildLayoutWrapper(AuthProvider authProvider, Widget child) {
    if (authProvider.authStatus == AuthStatus.authenticated) {
      // Si está autenticado, siempre usar DashboardLayout
      return DashboardLayout(child: child);
    } else {
      // Si no está autenticado, siempre usar AuthLayout
      return AuthLayout(child: child);
    }
  }
}
