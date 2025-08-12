import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/register_form_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _handleRegister(
    RegisterFormProvider registerFormProvider,
  ) async {
    final validForm = registerFormProvider.validateForm();
    if (!validForm) return;

    // Prevenir múltiples ejecuciones
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      print('🔄 Iniciando registro...');

      final success = await authProvider.register(
        registerFormProvider.email,
        registerFormProvider.password,
        registerFormProvider.name,
      );

      print('📋 Resultado del registro: $success');

      // Si el registro falló, resetear el estado
      if (!success && mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // Si fue exitoso, el AuthProvider maneja la navegación
    } catch (e) {
      print('❌ Error en _handleRegister: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterFormProvider(),
      child: Builder(
        builder: (context) {
          final registerFormProvider = Provider.of<RegisterFormProvider>(
            context,
            listen: false,
          );
          return Container(
            margin: EdgeInsets.only(top: 50), // Reducir margen
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 370),
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: registerFormProvider.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Agregar esto
                    children: [
                      TextFormField(
                        onChanged: (value) => registerFormProvider.name = value,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Este campo es obligatorio';
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: CustomInputs.loginInputDecoration(
                          hint: 'Ingrese su nombre',
                          label: 'Nombre',
                          icon: Icons.person_outline,
                        ),
                      ),

                      SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) =>
                            registerFormProvider.email = value,
                        validator: (value) {
                          if (!EmailValidator.validate(value ?? ''))
                            return 'Email no válido';
                          return null;
                        },
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
                            registerFormProvider.password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Ingrese su contraseña';
                          if (value.length < 6)
                            return 'La contraseña debe tener al menos 6 caracteres';
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
                          onPressed: () async {
                            // Verificar si ya está cargando antes de proceder
                            if (_isLoading) return;

                            await _handleRegister(registerFormProvider);
                          },
                          text: _isLoading
                              ? 'Creando cuenta...'
                              : 'Crear cuenta',
                          color: Colors.grey,
                          isFilled: true,
                        ),
                      ),

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Ya tienes cuenta? ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          LinkText(
                            text: 'inicia sesión',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                Flurorouter.loginRoute,
                              );
                            },
                          ),
                        ],
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
