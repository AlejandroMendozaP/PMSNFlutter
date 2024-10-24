import 'package:dio/dio.dart';
import 'package:flutter_application_2/models/popular_moviedao.dart';

class PopularApi {

  final dio = Dio();

  Future <List<PopularMovieDao>> getPopularMovies() async {
    final response = await dio.get('https://api.themoviedb.org/3/movie/popular?api_key=5019e68de7bc112f4e4337a500b96c56&language=es-MX&page=1');
    final res = response.data['results'] as List;

    return res.map((popular) => PopularMovieDao.fromMap(popular)).toList();
  }
}