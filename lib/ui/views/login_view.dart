import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/login_form_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:admin_dashboard/ui/buttons/google_signin_button.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => LoginFormProvider(),
      child: Builder(
        builder: (context) {
          final loginFormProvider = Provider.of<LoginFormProvider>(
            context,
            listen: false,
          );
          return Container(
            margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.black,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 370),
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: loginFormProvider.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (!EmailValidator.validate(value ?? '')) {
                            return 'Email no válido';
                          }
                          return null;
                        },
                        onChanged: (value) => loginFormProvider.email = value,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: CustomInputs.loginInputDecoration(
                          hint: 'Ingrese su correo',
                          label: 'Correo',
                          icon: Icons.email_outlined,
                        ),
                      ),

                      SizedBox(height: 20),

                      TextFormField(
                        onChanged: (value) =>
                            loginFormProvider.password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                        obscureText: _obscurePassword,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration:
                            CustomInputs.loginInputDecoration(
                              hint: '*********',
                              label: 'Contraseña',
                              icon: Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                      ),

                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: CustomOutlinedButton(
                          onPressed: () {
                            final isValid = loginFormProvider.validateForm();
                            if (isValid) {
                              authProvider.login(
                                loginFormProvider.email,
                                loginFormProvider.password,
                              );
                              // Proceed with login
                            }
                          },
                          text: 'Ingresar',
                          color: Colors.blueGrey,
                          isFilled: true,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Separador
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'O',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Botón de Google Sign-In
                      GoogleSignInButton(
                        onPressed: () async {
                          await authProvider.signInWithGoogle();
                        },
                        isLoading:
                            authProvider.authStatus == AuthStatus.checking,
                      ),

                      SizedBox(height: 20),
                      LinkText(
                        text: 'Registrar nueva cuenta',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Flurorouter.registerRoute,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
