class SalesDAO {
  int? idSale;
  String title;
  String description;
  String date;
  int idItem;
  int quantity;
  String status;

  SalesDAO({
    this.idSale,
    required this.title,
    required this.description,
    required this.date,
    required this.idItem,
    required this.quantity,
    required this.status
});

  // Convertir el modelo a un mapa (para operaciones CRUD)
  Map<String, dynamic> toMap() {
    return {
      'idSale': idSale,
      'title': title,
      'description': description,
      'date': date,
      'idItem': idItem,
      'quantity': quantity,
      'status': status,
    };
  }

  // Convertir un mapa en una instancia del modelo
  factory SalesDAO.fromMap(Map<String, dynamic> map) {
    return SalesDAO(
      idSale: map['idSale'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      idItem: map['idItem'],
      quantity: map['quantity'],
      status: map['status'],
    );
  }
}
