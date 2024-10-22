class Item {
  int? idItem;
  String productName;
  double price;
  int categoryId;

  Item({
    this.idItem,
    required this.productName,
    required this.price,
    required this.categoryId
  });

  // Convertir el modelo a un mapa (para operaciones CRUD)
  Map<String, dynamic> toMap() {
    return {
      'idItem': idItem,
      'productName': productName,
      'price': price,
      'categoryId': categoryId
    };
  }

  // Convertir un mapa en una instancia del modelo
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      idItem: map['idItem'],
      productName: map['productName'],
      price: map['price'],
      categoryId: map['categoryId']
    );
  }
}
