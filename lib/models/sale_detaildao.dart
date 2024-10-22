class SaleDetail {
  int? idSaleDetail;
  int idSale;
  int idItem;
  int quantity;
  double totalPrice;

  SaleDetail({
    this.idSaleDetail,
    required this.idSale,
    required this.idItem,
    required this.quantity,
    required this.totalPrice,
  });

  // Convertir el modelo a un mapa (para operaciones CRUD)
  Map<String, dynamic> toMap() {
    return {
      'idSaleDetail': idSaleDetail,
      'idSale': idSale,
      'idItem': idItem,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  // Convertir un mapa en una instancia del modelo
  factory SaleDetail.fromMap(Map<String, dynamic> map) {
    return SaleDetail(
      idSaleDetail: map['idSaleDetail'],
      idSale: map['idSale'],
      idItem: map['idItem'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
    );
  }
}
