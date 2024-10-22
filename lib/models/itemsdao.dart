class Item {
  int? idItem;
  int saleId;
  String productName;
  int quantity;
  double price;

  Item({
    this.idItem,
    required this.saleId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  // Convertir el modelo a un mapa (para operaciones CRUD)
  Map<String, dynamic> toMap() {
    return {
      'idItem': idItem,
      'saleId': saleId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  // Convertir un mapa en una instancia del modelo
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      idItem: map['idItem'],
      saleId: map['saleId'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
