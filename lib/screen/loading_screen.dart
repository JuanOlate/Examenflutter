import 'package:flutter/material.dart';
// Definición de un widget sin estado (StatelessWidget) para mostrar una pantalla de carga.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
    // Método build que construye la interfaz de usuario para la pantalla de carga.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoadingScreen'),
      ),
      // Cuerpo de la pantalla que muestra un mensaje de carga centrado.
      body: const Center(
        child: Text('LoadingScreen'),
      ),
    );
  }
}
