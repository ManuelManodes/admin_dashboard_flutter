import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhiteCard extends StatelessWidget {
  final String? title; // Cambiar a nullable
  final Widget child;
  final double? width;

  const WhiteCard({
    Key? key,
    required this.child,
    this.title,
    this.width,
  }) // title ahora es opcional
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? width : null,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(10),
      decoration: buildBoxDecoration(), // Corregir el nombre del método
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                title!,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8), // Agregar espacio entre título y contenido
          ],
          child,
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
    // Corregir el nombre del método
    color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
  );
}
