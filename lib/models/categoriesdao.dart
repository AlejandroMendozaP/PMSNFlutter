class Category {
  int? idCategory;
  String nameCategory;

  Category({this.idCategory, required this.nameCategory});

  // Convertir el modelo a un mapa (para operaciones CRUD)
  Map<String, dynamic> toMap() {
    return {
      'idCategory': idCategory,
      'nameCategory': nameCategory,
    };
  }

  // Convertir un mapa en una instancia del modelo
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      idCategory: map['idCategory'],
      nameCategory: map['nameCategory'],
    );
  }
}
