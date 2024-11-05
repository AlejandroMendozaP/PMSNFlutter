import 'package:dio/dio.dart';
import 'package:flutter_application_2/models/popular_cast.dart';
import 'package:flutter_application_2/models/popular_moviedao.dart';
import 'package:flutter_application_2/models/popular_trailerdao.dart';

class PopularApi {
  final dio = Dio();

  Future <List<PopularMovieDao>> getPopularMovies() async {
    final response = await dio.get('https://api.themoviedb.org/3/movie/popular?api_key=506386d76b16937247b6f1354b597689&language=es-MX&page=1');
    final res = response.data['results'] as List;

    return res.map((popular) => PopularMovieDao.fromMap(popular)).toList();
  }

  Future<String?> getTrailerKey(int movieId) async {
    final response = await dio.get(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=506386d76b16937247b6f1354b597689&language=en-US');

    final results = response.data['results'] as List;

    for (var video in results) {
      if (video['type'] == 'Trailer') {
        return video['key'];
      }
    }
    return null; // Si no se encuentra un trailer
  }

  Future<List<PopularCast>> getMovieCast(int movieId) async {
    final response = await dio.get(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=506386d76b16937247b6f1354b597689&language=es-MX&append_to_response=credits');

    // Extraer solo la lista de cast dentro de credits
    final castData = response.data['credits']['cast'] as List;

    // Mapear cada elemento de castData a un objeto PopularCast
    return castData.map((cast) => PopularCast.fromMap(cast)).toList();
  }
}