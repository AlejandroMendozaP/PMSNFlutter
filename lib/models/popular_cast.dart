class PopularCast {
  bool adult;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String profilePath;
  int castId;
  String character;
  String creditId;
  int order;

  PopularCast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  factory PopularCast.fromMap(Map<String, dynamic> popular) {
    return PopularCast(
      adult: popular['adult'] ?? false,
      gender: popular['gender'] ?? 0,
      id: popular['id'] ?? 0,
      knownForDepartment: popular['knownForDepartment'] ?? '',
      name: popular['name'] ?? '',
      originalName: popular['originalName'] ?? '',
      popularity: (popular['popularity'] ?? 0).toDouble(),
      profilePath: popular['profile_path'] ?? '',
      castId: popular['castId'] ?? 0,
      character: popular['character'] ?? '',
      creditId: popular['creditId'] ?? '',
      order: popular['order'] ?? 0,
    );
  }
}
