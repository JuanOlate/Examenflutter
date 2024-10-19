import 'package:examen_flutter/screen/category.dart';
import 'package:examen_flutter/services/service.dart';
import 'package:flutter/material.dart';
// Definición de un StatefulWidget para gestionar el estado de la página de categorías.
class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = Service().fetchCategories();
  }
  // Construye la interfaz de usuario para la página de categorías.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Categorías'),
      ),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Category category = snapshot.data![index];
                return ListTile(
                  title: Text(category.name),
                  subtitle: Text(category.state),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditCategoryDialog(category),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _confirmDelete(category),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No hay datos disponibles.')); // Mensaje cuando no hay datos.
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(),
        tooltip: 'Agregar Categoría',
        child: Icon(Icons.add),
      ),
    );
  }
  // Muestra un cuadro de diálogo para agregar una nueva categoría.
  void _showAddCategoryDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Nueva Categoría'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Nombre de la Categoría",
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
                Service()
                    .addCategory(
                  name: nameController.text,
                )
                    .then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureCategories = Service().fetchCategories();
                  });
                }).catchError((error) {
                  print('Error al añadir categoría: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }
  // Muestra un cuadro de diálogo para editar una categoría existente.
  void _showEditCategoryDialog(Category category) {
    TextEditingController nameController =
        TextEditingController(text: category.name);
    TextEditingController stateController =
        TextEditingController(text: category.state);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Categoría'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Nombre de la Categoría",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: stateController,
                decoration: InputDecoration(
                  hintText: "Estado de la Categoría",
                ),
              ),
            ],
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
                Service()
                    .editCategory(
                  categoryId: category.id,
                  name: nameController.text,
                  state: stateController.text,
                )
                    .then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureCategories = Service().fetchCategories();
                  });
                }).catchError((error) {
                  print('Error al editar categoría: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }
  // Muestra un cuadro de diálogo para confirmar la eliminación de una categoría.
  void _confirmDelete(Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de querer eliminar esta categoría?'),
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
                Service().deleteCategory(category.id).then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureCategories = Service().fetchCategories();
                  });
                }).catchError((error) {
                  print('Error al eliminar categoría: $error');
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
