import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String name = '';

  validateForm() {
    if (formKey.currentState!.validate()) {
      print('Formulario válido... register    ');
      print('$email' == '$password' && '$name' == '$email');
    } else {
      print('Formulario inválido... ');
    }
  }
}
