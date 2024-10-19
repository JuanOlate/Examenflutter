import 'package:examen_flutter/screen/supplier.dart';
import 'package:examen_flutter/services/service.dart';
import 'package:flutter/material.dart';
// Esta clase representa la página de proveedores
class SuppliersPage extends StatefulWidget {
  @override
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
    // Declaración de la variable para almacenar la lista de proveedores futura
  late Future<List<Supplier>> futureSuppliers;

  @override
  void initState() {
    super.initState();
    futureSuppliers = Service().fetchSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Proveedores'),
      ),
      body: FutureBuilder<List<Supplier>>(
        future: futureSuppliers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Supplier supplier = snapshot.data![index];
                return ListTile(
                  title: Text(supplier.name),
                  subtitle: Text(supplier.lastName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditSupplierDialog(supplier),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _confirmDelete(supplier),
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
        onPressed: () => _showAddSupplierDialog(),
        tooltip: 'Agregar Proveedor',
        child: Icon(Icons.add),
      ),
    );
  }
  // Método para mostrar el diálogo de agregar proveedor
  void _showAddSupplierDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController stateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Nuevo Proveedor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Nombre del Proveedor",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  hintText: "Apellido del Proveedor",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Correo del Proveedor",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: stateController,
                decoration: InputDecoration(
                  hintText: "Estado del Proveedor",
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
              child: Text('Aceptar'),
              onPressed: () {
                Service()
                    .addSupplier(
                  name: nameController.text,
                  lastName: lastNameController.text,
                  email: emailController.text,
                  state: stateController.text,
                )
                    .then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureSuppliers = Service().fetchSuppliers();
                  });
                }).catchError((error) {
                  print('Error al agregar proveedor: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }
  // Método para mostrar el diálogo de editar proveedor
  void _showEditSupplierDialog(Supplier supplier) {
    TextEditingController nameController =
        TextEditingController(text: supplier.name);
    TextEditingController lastNameController =
        TextEditingController(text: supplier.lastName);
    TextEditingController emailController =
        TextEditingController(text: supplier.email);
    TextEditingController stateController =
        TextEditingController(text: supplier.state);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Proveedor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Nombre del Proveedor",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  hintText: "Apellido del Proveedor",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Correo del Proveedor",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: stateController,
                decoration: InputDecoration(
                  hintText: "Estado del Proveedor",
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
                    .editSupplier(
                  supplierId: supplier.id,
                  name: nameController.text,
                  lastName: lastNameController.text,
                  email: emailController.text,
                  state: stateController.text,
                )
                    .then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureSuppliers = Service().fetchSuppliers();
                  });
                }).catchError((error) {
                  print('Error al editar proveedor: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }
  // Método para mostrar el diálogo de confirmación de eliminación
  void _confirmDelete(Supplier supplier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de querer eliminar este proveedor?'),
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
                try {
                  Service().deleteSupplier(supplier.id).then((_) {
                    Navigator.of(context).pop();
                    setState(() {
                      futureSuppliers = Service().fetchSuppliers();
                    });
                  });
                } catch (error) {
                  print('Error al eliminar proveedor: $error');
                  Navigator.of(context).pop();
                  // Puedes mostrar un mensaje de error al usuario aquí
                }
              },
            ),
          ],
        );
      },
    );
  }
}
