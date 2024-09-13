import 'package:flutter/material.dart';
import 'package:flutter_application_2/database/movies_database.dart';
import 'package:flutter_application_2/models/moviesdao.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {

  late MoviesDatabase moviesDB;
  @override
  void initState() {
    super.initState();
    moviesDB = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies List'),),
      body: FutureBuilder(
        future: moviesDB.SELECT(),
        builder: (context, AsyncSnapshot<List<MoviesDAO>> snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemBuilder: (context, index) {
                
              },
          );
          }else{
            if(snapshot.hasError){
              return const Center(child: Text('Something was wrong'),);
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          }
        }
      ),
    );
  }
}