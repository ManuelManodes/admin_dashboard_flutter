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
          } else {
            print('📢 Notification (console): $message');
          }
        });
      }
    } catch (e) {
      print('📢 Notification error, showing in console: $message');
      print('Error: $e');
    }
  }
}
