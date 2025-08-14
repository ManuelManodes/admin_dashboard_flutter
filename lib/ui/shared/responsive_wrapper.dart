import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double minWidth;
  final double minHeight;

  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.minWidth = 900,
    this.minHeight = 900,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular las dimensiones efectivas
        final effectiveWidth = constraints.maxWidth < minWidth
            ? minWidth
            : constraints.maxWidth;
        final effectiveHeight = constraints.maxHeight < minHeight
            ? minHeight
            : constraints.maxHeight;

        // Si las dimensiones actuales son menores a las mínimas, usar scroll
        final needsHorizontalScroll = constraints.maxWidth < minWidth;
        final needsVerticalScroll = constraints.maxHeight < minHeight;

        Widget content = Container(
          width: effectiveWidth,
          height: effectiveHeight,
          child: child,
        );

        // Aplicar scroll horizontal si es necesario
        if (needsHorizontalScroll) {
          content = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: content,
          );
        }

        // Aplicar scroll vertical si es necesario
        if (needsVerticalScroll) {
          content = SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: content,
          );
        }

        // Si necesita ambos scrolls, usar un scroll bidimensional
        if (needsHorizontalScroll && needsVerticalScroll) {
          content = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: effectiveWidth,
                height: effectiveHeight,
                child: child,
              ),
            ),
          );
        }

        return content;
      },
    );
  }
}

// Utilidad para obtener dimensiones efectivas
class ResponsiveUtils {
  static Size getEffectiveSize(
    BuildContext context, {
    double minWidth = 900,
    double minHeight = 900,
  }) {
    final size = MediaQuery.of(context).size;
    return Size(
      size.width < minWidth ? minWidth : size.width,
      size.height < minHeight ? minHeight : size.height,
    );
  }

  static double getEffectiveWidth(
    BuildContext context, {
    double minWidth = 900,
  }) {
    final width = MediaQuery.of(context).size.width;
    return width < minWidth ? minWidth : width;
  }

  static double getEffectiveHeight(
    BuildContext context, {
    double minHeight = 900,
  }) {
    final height = MediaQuery.of(context).size.height;
    return height < minHeight ? minHeight : height;
  }

  // Breakpoints responsivos basados en el ancho efectivo
  static bool isLargeScreen(BuildContext context) {
    return getEffectiveWidth(context) >= 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = getEffectiveWidth(context);
    return width >= 900 && width < 1200;
  }

  static bool isSmallScreen(BuildContext context) {
    return getEffectiveWidth(context) <
        900; // Esto no debería ocurrir con nuestras restricciones
  }
}
