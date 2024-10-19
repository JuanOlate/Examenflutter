import 'package:examen_flutter/screen/categorie_page.dart';
import 'package:examen_flutter/screen/supplier_page.dart';
import 'package:flutter/material.dart';

import 'products_page.dart';
// Definición de un widget sin estado (StatelessWidget) para la página principal de la aplicación.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  // Método build que construye la interfaz de usuario para la página principal.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
// Definición de un widget sin estado (StatelessWidget) para la pantalla de inicio.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuppliersPage()),
                );
              },
              child: Text('Proveedores'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                );
              },
              child: Text('Categorías'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsPage()),
                );
              },
              child: Text('Productos'),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
