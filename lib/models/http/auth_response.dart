import 'dart:convert';

class AuthResponse {
  Usuario usuario;
  String token;

  AuthResponse({required this.usuario, required this.token});

  factory AuthResponse.fromRawJson(String str) =>
      AuthResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    usuario: Usuario.fromJson(json["usuario"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "usuario": usuario.toJson(),
    "token": token,
  };
}

class Usuario {
  String nombre;
  String correo;
  String rol;
  bool estado;
  bool google;
  String uid;

  Usuario({
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.estado,
    required this.google,
    required this.uid,
  });

  factory Usuario.fromRawJson(String str) => Usuario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    nombre: json["nombre"],
    correo: json["correo"],
    rol: json["rol"],
    estado: json["estado"],
    google: json["google"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "correo": correo,
    "rol": rol,
    "estado": estado,
    "google": google,
    "uid": uid,
  };
}
