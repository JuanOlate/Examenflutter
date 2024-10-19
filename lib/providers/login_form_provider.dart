import 'package:flutter/material.dart';
// LoginFormProvider extiende ChangeNotifier, permitiendo notificar a los listeners sobre cambios.
class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
 // Variables para almacenar el email y la contraseña del usuario.
  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }
// Método para validar el formulario. Devuelve true si el formulario es válido; de lo contrario, false.
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
