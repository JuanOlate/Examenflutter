import 'package:flutter/material.dart';
// Definición de un widget sin estado (StatelessWidget) para mostrar una pantalla de error.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ErrorScreen'),
      ),
      body: const Center(
        child: Text('ErrorScreen'),
      ),
    );
  }
}
