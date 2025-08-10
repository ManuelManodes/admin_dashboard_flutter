import 'package:flutter/material.dart';
import 'package:admin_dashboard/services/local_storage.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static navigateTo(String routeName) {
    _saveLastRoute(routeName);
    print('⭐ Navegando a: $routeName');
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  static replaceTo(String routeName) {
    _saveLastRoute(routeName);
    print('⭐ Reemplazando a: $routeName');
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  // Método para limpiar historial (necesario para Opción 1)
  static navigateToAndClear(String routeName) {
    _saveLastRoute(routeName);
    print('⭐ Navegando con limpieza a: $routeName');
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false, // Esto elimina todas las rutas anteriores
    );
  }

  static goBack() {
    print('⭐ Volviendo atrás');
    return navigatorKey.currentState!.pop();
  }

  // Guardar la última ruta visitada (solo rutas del dashboard)
  static _saveLastRoute(String routeName) {
    if (routeName.startsWith('/dashboard')) {
      LocalStorage.prefs.setString('lastRoute', routeName);
      print('💾 Guardada última ruta: $routeName');

      // Verificación inmediata (para confirmar que se guardó)
      final savedRoute = LocalStorage.prefs.getString('lastRoute');
      print('✅ Verificación de guardado: $savedRoute');
    }
  }

  // Obtener la última ruta guardada
  static String? getLastRoute() {
    final route = LocalStorage.prefs.getString('lastRoute');
    print('🔍 Recuperando última ruta: $route');
    return route;
  }

  // Limpiar la última ruta (útil en logout)
  static clearLastRoute() {
    print('🗑️ Limpiando última ruta');
    LocalStorage.prefs.remove('lastRoute');
  }

  // Función de depuración para verificar el estado de LocalStorage
  static void debugLocalStorage() {
    final lastRoute = LocalStorage.prefs.getString('lastRoute');
    final token = LocalStorage.prefs.getString('token');
    print('📊 DEBUG LOCALSTORAGE:');
    print('📍 Última ruta: $lastRoute');
    print('🔑 Token: $token');
  }
}
