import 'dart:convert';

import 'package:examen_flutter/screen/category.dart';
import 'package:examen_flutter/screen/product.dart';
import 'package:examen_flutter/screen/supplier.dart';
import 'package:http/http.dart' as http;
// Clase de servicio para realizar solicitudes HTTP a la API
class Service {
  // URL base de la API
  static const String baseUrl = 'http://143.198.118.203:8100/ejemplos/';
   // Credenciales de autenticación básicas
  static const String username = 'test';
  static const String password = 'test2023';
  // Método para obtener los encabezados de autenticación
  Map<String, String> get authHeaders {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }
  // Método para obtener la lista de categorías desde la API
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(baseUrl + 'category_list_rest/'),
        headers: authHeaders);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> categoryData = jsonData['Listado Categorias'];
      List<Category> categories = categoryData
          .map((data) => Category(
                id: data['category_id'],
                name: data['category_name'],
                state: data['category_state'],
              ))
          .toList();
      return categories;
    } else {
      throw Exception(
          'Failed to load categories with status code: ${response.statusCode}');
    }
  }
  // Método para agregar una nueva categoría a través de la API
  Future<void> addCategory({required String name}) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'category_add_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'category_name': name,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to add category with status code: ${response.statusCode}');
    }
  }
  // Método para eliminar una categoría a través de la API
  Future<void> deleteCategory(int categoryId) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'category_del_rest/'),
      headers: authHeaders,
      body: jsonEncode({'category_id': categoryId}),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete category with status code: ${response.statusCode}');
    }
  }
  // Método para editar una categoría existente a través de la API
  Future<void> editCategory(
      {required int categoryId,
      required String name,
      required String state}) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'category_edit_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'category_id': categoryId,
        'category_name': name,
        'category_state': state,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to edit category with status code: ${response.statusCode}');
    }
  }
  // Método para obtener la lista de productos desde la API
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl + 'product_list_rest/'),
        headers: authHeaders);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['Listado'];
      List<Product> products =
          jsonData.map((data) => Product.fromJson(data)).toList();
      return products;
    } else {
      throw Exception(
          'Failed to load products with status code: ${response.statusCode}');
    }
  }
  // Método para agregar un nuevo producto a través de la API
  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'product_add_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'product_name': product.name,
        'product_price': product.price,
        'product_image': product.imageUrl
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to add product with status code: ${response.statusCode}');
    }
  }
  // Método para eliminar un producto a través de la API
  Future<void> deleteProduct(int productId) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'product_del_rest/'),
      headers: authHeaders,
      body: jsonEncode({'product_id': productId}),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete product with status code: ${response.statusCode}');
    }
  }
  // Método para editar un producto existente a través de la API
  Future<void> editProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'product_edit_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'product_id': product.id,
        'product_name': product.name,
        'product_price': product.price,
        'product_image': product.imageUrl,
        'product_state': product.state
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to edit product with status code: ${response.statusCode}');
    }
  }
  // Método para obtener la lista de proveedores desde la API
  Future<List<Supplier>> fetchSuppliers() async {
    final response = await http.get(Uri.parse(baseUrl + 'provider_list_rest/'),
        headers: authHeaders);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> supplierData = jsonData['Proveedores Listado'];
      List<Supplier> suppliers = supplierData
          .map((data) => Supplier(
                id: data['providerid'],
                name: data['provider_name'],
                lastName: data['provider_last_name'],
                email: data['provider_mail'],
                state: data['provider_state'],
              ))
          .toList();
      return suppliers;
    } else {
      throw Exception(
          'Failed to load suppliers with status code: ${response.statusCode}');
    }
  }
  // Método para agregar un nuevo proveedor a través de la API
  Future<void> addSupplier({
    required String name,
    required String lastName,
    required String email,
    required String state,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'provider_add_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'provider_name': name,
        'provider_last_name': lastName,
        'provider_mail': email,
        'provider_state': state,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to add supplier with status code: ${response.statusCode}');
    }
  }
  // Método para editar un proveedor existente a través de la API
  Future<void> editSupplier({
    required int supplierId,
    required String name,
    required String lastName,
    required String email,
    required String state,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'provider_edit_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'provider_id': supplierId,
        'provider_name': name,
        'provider_last_name': lastName,
        'provider_mail': email,
        'provider_state': state,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to edit supplier with status code: ${response.statusCode}');
    }
  }
  // Método para eliminar un proveedor a través de la API
  Future<void> deleteSupplier(int supplierId) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'provider_del_rest/'),
      headers: authHeaders,
      body: jsonEncode({'provider_id': supplierId}),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete supplier with status code: ${response.statusCode}');
    }
  }
}
