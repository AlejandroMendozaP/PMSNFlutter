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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(popular?.title ?? 'Detalle de la película'),
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
                    height: 150, // Altura de la lista horizontal
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
