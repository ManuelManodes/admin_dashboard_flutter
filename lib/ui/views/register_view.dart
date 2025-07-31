import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.black,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 370),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white, // ✅ Cursor blanco
                  decoration: CustomInputs.loginInputDecoration(
                    hint: 'Ingrese su nombre',
                    label: 'Nombre',
                    icon: Icons.person_outline,
                  ),
                ),

                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white, // ✅ Cursor blanco
                  decoration: CustomInputs.loginInputDecoration(
                    hint: 'Ingrese su correo',
                    label: 'Correo',
                    icon: Icons.email_outlined,
                  ),
                ),

                SizedBox(height: 20),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: CustomInputs.loginInputDecoration(
                    hint: '*********',
                    label: 'Contraseña',
                    icon: Icons.lock_outline,
                  ),
                ),

                SizedBox(height: 20),
                SizedBox(
                  width: double
                      .infinity, // ✅ Fuerza al botón a ocupar todo el ancho
                  child: CustomOutlinedButton(
                    onPressed: () {},
                    text: 'Crear cuenta',
                    color: Colors.blueGrey,
                    isFilled: true,
                  ),
                ),

                SizedBox(height: 20),
                LinkText(
                  text: '¿Ya tienes cuenta?',
                  onPressed: () {
                    Navigator.pushNamed(context, Flurorouter.loginRoute);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
