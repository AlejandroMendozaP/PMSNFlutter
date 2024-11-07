import 'package:dio/dio.dart';
import 'package:flutter_application_2/models/popular_cast.dart';
import 'package:flutter_application_2/models/popular_moviedao.dart';

class PopularApi {
  final dio = Dio();

  Future <List<PopularMovieDao>> getPopularMovies() async {
    final response = await dio.get('https://api.themoviedb.org/3/movie/popular?api_key=506386d76b16937247b6f1354b597689&language=es-MX&page=1');
    final res = response.data['results'] as List;

    return res.map((popular) => PopularMovieDao.fromMap(popular)).toList();
  }

  Future <List<PopularMovieDao>> getFavoritesMovies() async {
    final response = await dio.get('https://api.themoviedb.org/3/list/8495832?api_key=506386d76b16937247b6f1354b597689&language=en-US&page=1');
    final res = response.data['items'] as List;

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

  Future<bool> addMovieToFavorites(int movieId) async {
    const url = 'https://api.themoviedb.org/3/list/8495832/add_item?session_id=5a897a6eb0c4ff73cd35cf844b3397b90558bae3';
      final response = await dio.post(
        url,
        data: {
          "media_id": movieId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MDYzODZkNzZiMTY5MzcyNDdiNmYxMzU0YjU5NzY4OSIsIm5iZiI6MTczMDcwMDI0Ni4yNjI2MTQ3LCJzdWIiOiI2NmZlZDk1MDllYmVhMTkwMDZmN2U1ZWQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.p4xgfKhLHx3WFNsNJREo2LjCfPQ7nWuE4uwxCwiOxRI',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ),
      );
    return true;
  }

  Future<bool> deleteMovieToFavorites(int movieId) async {
    const url = 'https://api.themoviedb.org/3/list/8495832/remove_item?session_id=5a897a6eb0c4ff73cd35cf844b3397b90558bae3';
    final response = await dio.post(
        url,
        data: {
          "media_id": movieId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MDYzODZkNzZiMTY5MzcyNDdiNmYxMzU0YjU5NzY4OSIsIm5iZiI6MTczMDcwMDI0Ni4yNjI2MTQ3LCJzdWIiOiI2NmZlZDk1MDllYmVhMTkwMDZmN2U1ZWQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.p4xgfKhLHx3WFNsNJREo2LjCfPQ7nWuE4uwxCwiOxRI',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ),
      );
    return true;
  }

  Future<bool> isMovieInFavorites(int movieId) async {
  final url = 'https://api.themoviedb.org/3/list/8495832/item_status?language=en-US&movie_id=$movieId';

  final response = await dio.get(url, options: Options(
    headers: {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MDYzODZkNzZiMTY5MzcyNDdiNmYxMzU0YjU5NzY4OSIsIm5iZiI6MTczMDcwMDI0Ni4yNjI2MTQ3LCJzdWIiOiI2NmZlZDk1MDllYmVhMTkwMDZmN2U1ZWQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.p4xgfKhLHx3WFNsNJREo2LjCfPQ7nWuE4uwxCwiOxRI',
      'Accept': 'application/json'
    },
  ));

  return response.data['item_present'];
}

  Future<List<Map<String, dynamic>>> getMovieReviews(int movieId) async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/$movieId/reviews?language=en-US&page=1',
      options: Options(
        headers: {
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MDYzODZkNzZiMTY5MzcyNDdiNmYxMzU0YjU5NzY4OSIsIm5iZiI6MTczMDk0MzI5NS4zNTE2ODI3LCJzdWIiOiI2NmZlZDk1MDllYmVhMTkwMDZmN2U1ZWQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.rkZjzWFsOPS72g1zYAl7xqtBTGGEf0FBtlMcl74N-xI',
          'Accept': 'application/json',
        },
      ),
    );

    final results = response.data['results'] as List;

    return results.map((review) {
      return {
        'author': review['author'],
        'avatar_path': review['author_details']['avatar_path'],
        'rating': review['author_details']['rating'],
        'content': review['content'],
      };
    }).toList();
  }
}
