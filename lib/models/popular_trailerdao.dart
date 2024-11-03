class PopularTrailerDao {
  String iso6391;
  String iso31661;
  String name;
  String key;
  String site;
  int size;
  String type;
  bool official;
  DateTime publishedAt;
  String id;

  PopularTrailerDao({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory PopularTrailerDao.fromMap(Map<String,dynamic> popular){
    return PopularTrailerDao(
    iso6391: popular['iso6391'],
    iso31661: popular['iso31661'],
    name: popular['name'],
    key: popular['key'],
    site: popular['site'],
    size: popular['size'],
    type: popular['type'],
    official: popular['official'],
    publishedAt: popular['publishedAt'],
    id: popular['id']
    );
  }

}
