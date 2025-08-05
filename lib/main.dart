import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/ui/layouts/auth/auth_layout.dart';
import 'package:admin_dashboard/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:admin_dashboard/ui/layouts/splash/splash_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.configurePrefs();
  Flurorouter.configureRoutes();
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: NavigationService.navigatorKey,
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
