import 'package:examen_flutter/services/service.dart';
import 'package:flutter/material.dart';

import 'product.dart'; // Asegúrate de que esta ruta de importación es correcta.
// Definición de un StatefulWidget para gestionar el estado de la página de productos.
class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}
// Estado asociado al StatefulWidget ProductsPage.
class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Product>> futureProducts;
  // Método initState que se llama cuando el objeto se inserta en el árbol de widgets.
  @override
  void initState() {
    super.initState();
    futureProducts = Service().fetchProducts();
  }
  // Construye la interfaz de usuario para la página de productos.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Product product = snapshot.data![index];
                return ListTile(
                  leading: Image.network(product.imageUrl),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditProductDialog(product),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _confirmDelete(product),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No hay datos disponibles.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(),
        tooltip: 'Agregar Producto',
        child: Icon(Icons.add),
      ),
    );
  }
  // Muestra un cuadro de diálogo para agregar un nuevo producto.
  void _showAddProductDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Nuevo Producto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Nombre del Producto",
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    hintText: "Precio del Producto",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    hintText: "URL de la Imagen del Producto",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Product newProduct = Product(
                  name: nameController.text,
                  price: int.parse(priceController.text),
                  imageUrl: imageUrlController.text,
                  id: 0, // El ID se ajustará en la API si es necesario
                  state: 'Activo',
                );
                Service().addProduct(newProduct).then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureProducts =
                        Service().fetchProducts(); // Recargar la lista
                  });
                }).catchError((error) {
                  print('Error al añadir producto: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(Product product) {
    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());
    TextEditingController imageUrlController =
        TextEditingController(text: product.imageUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Producto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Nombre del Producto",
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    hintText: "Precio del Producto",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    hintText: "URL de la Imagen del Producto",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar Cambios'),
              onPressed: () {
                Product updatedProduct = Product(
                  id: product.id,
                  name: nameController.text,
                  price: int.parse(priceController.text),
                  imageUrl: imageUrlController.text,
                  state: product.state,
                );
                Service().editProduct(updatedProduct).then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureProducts =
                        Service().fetchProducts(); // Recargar la lista
                  });
                }).catchError((error) {
                  print('Error al editar producto: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de querer eliminar este producto?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Service().deleteProduct(product.id).then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureProducts =
                        Service().fetchProducts(); // Recargar la lista
                  });
                }).catchError((error) {
                  print('Error al eliminar producto: $error');
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
