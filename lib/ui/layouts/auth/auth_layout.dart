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
      child: SingleChildScrollView(
        // Remover Scrollbar para evitar errores
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CustomTitle(),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: child,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 200,
                child: BackgroundCustom(),
              ),
              SizedBox(height: 10),
            ],
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
            child: Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    children: [
                      // Agregar CustomTitle aquí
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: CustomTitle(),
                      ),
                      SizedBox(height: 40),
                      // Contenido del formulario
                      Container(
                        constraints: BoxConstraints(maxWidth: 370),
                        child: child,
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
