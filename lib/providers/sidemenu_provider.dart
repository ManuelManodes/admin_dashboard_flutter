import 'package:flutter/material.dart';

class SideMenuProvider extends ChangeNotifier {
  // ✅ Agregado extends ChangeNotifier
  static late AnimationController menuController;
  static bool isOpen = false;

  String _currentPage = '';

  String get currentPage {
    return _currentPage;
  }

  void setCurrentPageUrl(String routeName) {
    _currentPage = routeName;
    Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners(); // ✅ Ahora funciona correctamente
    });
  }

  static Animation<double> get movement =>
      menuController.drive(Tween<double>(begin: -250.0, end: 0.0));

  static Animation<double> opacity = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(CurvedAnimation(parent: menuController, curve: Curves.easeInOut));

  static void openMenu() {
    isOpen = true;
    menuController.forward();
  }

  static void closeMenu() {
    isOpen = false;
    menuController.reverse();
  }

  static void toggleMenu() {
    (isOpen) ? closeMenu() : openMenu();
    isOpen = !isOpen;
  }
}
