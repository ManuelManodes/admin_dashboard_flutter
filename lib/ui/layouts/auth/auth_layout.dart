import 'package:admin_dashboard/ui/layouts/auth/widgets/background_custom.dart';
import 'package:admin_dashboard/ui/layouts/auth/widgets/custom_title.dart';
import 'package:admin_dashboard/ui/layouts/auth/widgets/links_bar.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: (size.width > 1000)
                ? _DesktopBody(child: child)
                : _MobileBody(child: child),
          ),
          // LinksBar - Siempre visible en la parte inferior
          LinksBar(),
        ],
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  final Widget child;

  const _MobileBody({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Scrollbar(
        thumbVisibility: true, // Siempre visible
        trackVisibility: true, // Track visible
        thickness: 8.0, // Grosor del scrollbar
        radius: Radius.circular(10.0), // Bordes redondeados
        scrollbarOrientation: ScrollbarOrientation.right,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  100, // Altura mínima menos el footer
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Título fijo en la parte superior
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CustomTitle(),
                  ),
                  SizedBox(height: 20),

                  // Contenido principal (Login View) - MÁS ESPACIO
                  Expanded(
                    flex: 3, // Más proporción para el login
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: child,
                    ),
                  ),

                  SizedBox(height: 20), // Menos espacio
                  // Imagen de fondo y logo - MENOS ESPACIO
                  Expanded(
                    flex: 2, // Menos proporción para la imagen
                    child: Container(
                      width: double.infinity,
                      height: 200, // Altura reducida
                      child: BackgroundCustom(),
                    ),
                  ),

                  SizedBox(height: 10), // Espacio mínimo antes del footer
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopBody extends StatelessWidget {
  final Widget child;

  const _DesktopBody({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        children: [
          // Background side
          Expanded(child: BackgroundCustom()),
          // Content side
          Container(
            width: 600,
            color: Colors.black,
            child: Column(
              children: [
                CustomTitle(),
                SizedBox(height: 50),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
