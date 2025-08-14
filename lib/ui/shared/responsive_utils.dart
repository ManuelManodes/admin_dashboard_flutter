import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Simplemente devolver el child sin restricciones mínimas
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: child,
        );
      },
    );
  }
}

// Utilidad para obtener dimensiones responsivas sin mínimos
class ResponsiveUtils {
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Breakpoints responsivos basados en el ancho real
  static bool isLargeScreen(BuildContext context) {
    return getScreenWidth(context) >= 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= 768 && width < 1200;
  }

  static bool isSmallScreen(BuildContext context) {
    return getScreenWidth(context) < 768;
  }

  static bool isTabletScreen(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= 600 && width < 768;
  }

  static bool isMobileScreen(BuildContext context) {
    return getScreenWidth(context) < 600;
  }

  // Helpers para padding y spacing responsivos
  static double getResponsivePadding(BuildContext context) {
    if (isLargeScreen(context)) return 20.0;
    if (isMediumScreen(context)) return 16.0;
    if (isTabletScreen(context)) return 12.0;
    return 8.0;
  }

  static double getResponsiveSpacing(BuildContext context) {
    if (isLargeScreen(context)) return 20.0;
    if (isMediumScreen(context)) return 16.0;
    if (isTabletScreen(context)) return 12.0;
    return 8.0;
  }

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isLargeScreen(context)) return baseSize;
    if (isMediumScreen(context)) return baseSize * 0.9;
    if (isTabletScreen(context)) return baseSize * 0.85;
    return baseSize * 0.8;
  }

  // Helper para determinar número de columnas en grids
  static int getGridColumns(BuildContext context, {int maxColumns = 4}) {
    if (isLargeScreen(context)) return maxColumns;
    if (isMediumScreen(context))
      return (maxColumns / 1.5).round().clamp(1, maxColumns);
    if (isTabletScreen(context))
      return (maxColumns / 2).round().clamp(1, maxColumns);
    return 1;
  }

  // Helper para altura de cards responsiva
  static double getCardHeight(BuildContext context, double baseHeight) {
    if (isLargeScreen(context)) return baseHeight;
    if (isMediumScreen(context)) return baseHeight * 0.9;
    if (isTabletScreen(context)) return baseHeight * 0.8;
    return baseHeight * 0.7;
  }
}
