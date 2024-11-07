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
  List<Map<String, dynamic>> reviews = []; // Nueva lista para almacenar reseñas
  bool isFavorite = false;

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
      _fetchReviews(); // Llamada a la función que obtiene las reseñas
    }
  }

  Future<void> _fetchTrailerAndCast() async {
    final api = PopularApi();
    final key = await api.getTrailerKey(popular!.id);
    final cast = await api.getMovieCast(popular!.id);
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

  Future<void> _fetchReviews() async {
    final api = PopularApi();
    final fetchedReviews = await api.getMovieReviews(popular!.id);
    setState(() {
      reviews = fetchedReviews;
    });
  }

  Future<void> _toggleFavorite() async {
    final api = PopularApi();
    if (isFavorite) {
      bool success = await api.deleteMovieToFavorites(popular!.id);
      if (success) {
        setState(() => isFavorite = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Película eliminada de favoritos')),
        );
      }
    } else {
      bool success = await api.addMovieToFavorites(popular!.id);
      if (success) {
        setState(() => isFavorite = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Película agregada a favoritos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          popular?.title ?? 'Detalle de la película',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/popularmovies'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500/${popular!.posterPath}',
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.7),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          progressColors: const ProgressBarColors(
                            playedColor: Color.fromARGB(255, 255, 7, 7),
                            handleColor: Color.fromARGB(255, 227, 0, 0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            color: const Color.fromARGB(255, 67, 67, 67).withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sinopsis',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    popular!.overview,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  RatingBarIndicator(
                                    rating: popular!.voteAverage / 2,
                                    itemBuilder: (context, index) =>
                                        const Icon(Icons.star, color: Colors.amber),
                                    itemCount: 5,
                                    itemSize: 30.0,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Reparto',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Reseñas',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: const Color.fromARGB(255, 67, 67, 67).withOpacity(0.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              review['avatar_path'] != null
                                                  ? 'https://image.tmdb.org/t/p/w200${review['avatar_path']}'
                                                  : 'https://via.placeholder.com/50',
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            review['author'] ?? 'Anonymous',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      RatingBarIndicator(
                                        rating: (review['rating'] ?? 0) / 2.0,
                                        itemBuilder: (context, index) =>
                                            const Icon(Icons.star, color: Colors.amber),
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        review['content'] ?? '',
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
