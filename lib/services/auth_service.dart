import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// Clase de servicio de autenticación que extiende ChangeNotifier para notificar cambios
class AuthService extends ChangeNotifier {
    // URL base de la API de autenticación
  final String _baseUrl = 'identitytoolkit.googleapis.com';
    // Token de Firebase para autenticación
  final String _firebaseToken = 'AIzaSyCwQYMMlROaHlO12wGuTuIwBxTezL2iBdU';
  // Método para iniciar sesión con email y contraseña
  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    // URL construida con la URL base, endpoint y el token de Firebase
    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});
    print(authData);
    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResponse = json.decode(response.body);
    if (decodeResponse.containsKey('idToken')) {
      return null;
    } else {
      return decodeResponse['error']['message'];
    }
  }

  Future<String?> create_user(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});
    print(authData);
    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResponse = json.decode(response.body);
    // Verifica si la respuesta contiene el idToken
    if (decodeResponse.containsKey('idToken')) {
      return null;
    } else {
      return decodeResponse['error']['message'];
    }
  }
}
