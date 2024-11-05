import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/popular_moviedao.dart';
import 'package:flutter_application_2/models/popular_cast.dart';
import 'package:flutter_application_2/network/popular_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailPopularScreen extends StatefulWidget {
  const DetailPopularScreen({super.key});

  @override
  State<DetailPopularScreen> createState() => _DetailPopularScreenState();
}

class _DetailPopularScreenState extends State<DetailPopularScreen> {
  late YoutubePlayerController _controller;
  bool isLoading = true;
  String? videoKey;
  PopularMovieDao? popular;
  List<PopularCast> castList = [];
  bool isFavorite = false; // Estado para controlar si es favorito

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (popular == null) {
      popular = ModalRoute.of(context)!.settings.arguments as PopularMovieDao;
      _fetchTrailerAndCast();
    }
  }

  Future<void> _fetchTrailerAndCast() async {
    final api = PopularApi();

    // Fetch trailer key
    final key = await api.getTrailerKey(popular!.id);

    // Fetch cast
    final cast = await api.getMovieCast(popular!.id);

    // Check if the movie is already in favorites
    isFavorite = await api.isMovieInFavorites(popular!.id);

    setState(() {
      videoKey = key;
      castList = cast;
      if (key != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoKey!,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      }
      isLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
  final api = PopularApi();

  if (isFavorite) {
    // Si la película ya es favorita, intenta eliminarla
    bool success = await api.deleteMovieToFavorites(popular!.id);
    if (success) {
      setState(() {
        isFavorite = false; // Cambia el estado del ícono a no favorito
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película eliminada de favoritos')),
      );
    } else {
      // Maneja el fallo al eliminar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar de favoritos')),
      );
    }
  } else {
    // Si la película no es favorita, intenta agregarla
    bool success = await api.addMovieToFavorites(popular!.id);
    if (success) {
      setState(() {
        isFavorite = true; // Cambia el estado del ícono a favorito
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película agregada a favoritos')),
      );
    } else {
      // Maneja el fallo al agregar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agregar a favoritos')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(popular?.title ?? 'Detalle de la película'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : const Color.fromARGB(255, 0, 0, 0),
            ),
            onPressed: _toggleFavorite, // Maneja el evento de presionar el ícono
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  opacity: 0.8,
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://image.tmdb.org/t/p/w500/${popular!.posterPath}',
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.amber,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.amberAccent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Sinopsis: ${popular!.overview}'),
                  ),
                  RatingBarIndicator(
                    rating: popular!.voteAverage / 2,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 50.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Reparto',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: castList.length,
                      itemBuilder: (context, index) {
                        final castMember = castList[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  'https://image.tmdb.org/t/p/w200/${castMember.profilePath}',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                castMember.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                castMember.character,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
