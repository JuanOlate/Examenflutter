// Definición de la clase Category para modelar los datos de una categoría.
class Category {
  final int id;
  final String name;
  final String state;
  // Constructor de la clase, inicializando todas las propiedades.
  Category({
    required this.id,
    required this.name,
    required this.state,
  });
  // Factory constructor que crea una instancia de Category a partir de un mapa JSON.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'],
      name: json['category_name'],
      state: json['category_state'],
    );
  }
}
