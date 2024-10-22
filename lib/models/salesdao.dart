class SalesDAO {
  int? idSale;
  String title;
  String description;
  String date;
  String status; 
  int categoryId;

  SalesDAO({
    this.idSale,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.categoryId,
  });

  // Convertir el modelo a un mapa (para operaciones CRUD)
  Map<String, dynamic> toMap() {
    return {
      'idSale': idSale,
      'title': title,
      'description': description,
      'date': date,
      'status': status,
      'categoryId': categoryId,
    };
  }

  // Convertir un mapa en una instancia del modelo
  factory SalesDAO.fromMap(Map<String, dynamic> map) {
    return SalesDAO(
      idSale: map['idSale'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      status: map['status'],
      categoryId: map['categoryId'],
    );
  }
}
