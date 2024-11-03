import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/popular_moviedao.dart';
import 'package:flutter_application_2/network/popular_api.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (popular == null) {
      popular = ModalRoute.of(context)!.settings.arguments as PopularMovieDao;
      _fetchTrailer();
    }
  }

  Future<void> _fetchTrailer() async {
    final api = PopularApi();
    final key = await api.getTrailerKey(popular!.id);

    if (key != null) {
      setState(() {
        videoKey = key;
        _controller = YoutubePlayerController(
          initialVideoId: videoKey!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(popular?.title ?? 'Detalle de la película'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ),
            ),
    );
  }
}
