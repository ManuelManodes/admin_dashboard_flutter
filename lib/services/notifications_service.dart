import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    try {
      final scaffoldMessenger = scaffoldMessengerKey.currentState;
      if (scaffoldMessenger != null && scaffoldMessenger.mounted) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(message), duration: Duration(seconds: 3)),
        );
      } else {
        // Reintentar después de un delay
        Future.delayed(Duration(milliseconds: 100), () {
          final retryScaffold = scaffoldMessengerKey.currentState;
          if (retryScaffold != null && retryScaffold.mounted) {
            retryScaffold.hideCurrentSnackBar();
            retryScaffold.showSnackBar(
              SnackBar(content: Text(message), duration: Duration(seconds: 3)),
            );
          }
        });
      }
    } catch (e) {
      // Error handling silencioso - no mostrar en consola
    }
  }

  // Nueva función para mensajes de éxito con estilo verde
  static showSuccessSnackbar(String message) {
    try {
      final scaffoldMessenger = scaffoldMessengerKey.currentState;
      if (scaffoldMessenger != null && scaffoldMessenger.mounted) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(message, style: TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: Color(0xFF27AE60), // Verde bonito
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Reintentar después de un delay
        Future.delayed(Duration(milliseconds: 100), () {
          final retryScaffold = scaffoldMessengerKey.currentState;
          if (retryScaffold != null && retryScaffold.mounted) {
            retryScaffold.hideCurrentSnackBar();
            retryScaffold.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text(message, style: TextStyle(color: Colors.white)),
                  ],
                ),
                backgroundColor: Color(0xFF27AE60), // Verde bonito
                duration: Duration(seconds: 3),
              ),
            );
          }
        });
      }
    } catch (e) {
      // Error handling silencioso - no mostrar en consola
    }
  }
}
