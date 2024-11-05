import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/popular_moviedao.dart';
import 'package:flutter_application_2/network/popular_api.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> with SingleTickerProviderStateMixin {
  PopularApi? popularApi;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    popularApi = PopularApi();
    _tabController = TabController(length: 2, vsync: this); // Inicializar el controlador del TabBar
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Popular Movies'),
            Tab(text: 'Favorite Movies'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPopularMoviesTab(),
          _buildFavoriteMoviesTab(),
        ],
      ),
    );
  }

  // Widget para mostrar películas populares
  Widget _buildPopularMoviesTab() {
    return FutureBuilder<List<PopularMovieDao>>(
      future: popularApi!.getPopularMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong :('));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No popular movies found'));
        } else {
          return GridView.builder(
            itemCount: snapshot.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              return CardPopupar(snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  // Widget para mostrar películas favoritas
  Widget _buildFavoriteMoviesTab() {
    return FutureBuilder<List<PopularMovieDao>>(
      future: popularApi!.getFavoritesMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong :('));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No favorite movies found'));
        } else {
          return GridView.builder(
            itemCount: snapshot.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              return CardPopupar(snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  // Widget de tarjeta de película
  Widget CardPopupar(PopularMovieDao popular) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: popular),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage('https://image.tmdb.org/t/p/w500/${popular.posterPath}'),
            ),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Opacity(
                opacity: 0.5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  height: 50,
                  child: Center(
                    child: Text(
                      popular.title,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
