import 'package:examen_flutter/screen/error_screen.dart';
import 'package:examen_flutter/screen/homepage.dart';
import 'package:examen_flutter/screen/login_screen.dart';
import 'package:examen_flutter/screen/register_user_screen.dart';
import 'package:flutter/material.dart';
// Define una clase para gestionar las rutas de la aplicación.
class AppRoutes {
  static const initialRoute = 'login';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'list': (BuildContext context) => const HomePage(),
    'add_user': (BuildContext context) => const RegisterUserScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}
