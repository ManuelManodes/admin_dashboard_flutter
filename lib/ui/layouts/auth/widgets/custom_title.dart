import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Image.asset('twitter-white-logo.png', width: 50, height: 50),

          SizedBox(height: 20),

          Text(
            'Bienvenido de vuelta',
            style: GoogleFonts.montserratAlternates(
              fontSize: (MediaQuery.of(context).size.width * 0.05).clamp(
                30.0,
                70.0,
              ),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
