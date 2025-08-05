import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  static replaceTo(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  // Método para limpiar historial (necesario para Opción 1)
  static navigateToAndClear(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false, // Esto elimina todas las rutas anteriores
    );
  }

  static goBack() {
    return navigatorKey.currentState!.pop();
  }
}
