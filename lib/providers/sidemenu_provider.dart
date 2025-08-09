import 'package:flutter/material.dart';

class SideMenuProvider {
  static late AnimationController menuController;
  static bool isOpen = false;

  static Animation<double> get movement => menuController.drive(
    Tween<double>(
      begin: -250.0, // Ancho negativo del sidebar para ocultarlo
      end: 0.0, // Posición visible
    ),
  );

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
