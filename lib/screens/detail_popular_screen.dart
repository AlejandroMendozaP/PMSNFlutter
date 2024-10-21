import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/popular_moviedao.dart';
import 'package:flutter_application_2/provider/test_provider.dart';
import 'package:provider/provider.dart';

class DetailPopularScreen extends StatefulWidget {
  const DetailPopularScreen({super.key});

  @override
  State<DetailPopularScreen> createState() => _DetailPopularScreenState();
}

class _DetailPopularScreenState extends State<DetailPopularScreen> {
  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments as PopularMovieDao;
    final testProvider = Provider.of<TestProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: ()=>testProvider.name = 'Alex'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.8,
            fit: BoxFit.fill,
            image: NetworkImage('https://image.tmdb.org/t/p/w500/${popular.posterPath}')
          )
        ),
      )
    );
  }
}