import 'package:flutter/material.dart';
import 'package:flutter_application_2/firebase/database_movies.dart';
import 'package:flutter_application_2/models/moviesdao.dart';
import 'package:flutter_application_2/views/movie_view_firebase.dart';
import 'package:flutter_application_2/views/movie_view_item_firebase.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MoviesScreenFirebase extends StatefulWidget {
  const MoviesScreenFirebase({super.key});

  @override
  State<MoviesScreenFirebase> createState() => _MoviesScreenFirebaseState();
}

class _MoviesScreenFirebaseState extends State<MoviesScreenFirebase> {
  DatabaseMovies? databaseMovies;

  @override
  void initState() {
    super.initState();
    databaseMovies = DatabaseMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies List'),
        actions: [
          IconButton(
            onPressed: (){
              WoltModalSheet.show(
                context: context,
                pageListBuilder: (context) => [
                  WoltModalSheetPage(
                    child: MovieViewFirebase()
                    )
                ],
              );
            },
            icon: const Icon (Icons.add)
            )
        ],
        ),
      body: StreamBuilder(
        stream: databaseMovies!.select(),
        builder:(context, snapshot){
          if (snapshot.hasData) {
            var movie = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                return MovieViewItemFirebase(moviesDAO: MoviesDAO.fromMap({
                  'idMovie' :'${snapshot.data!.docs[index].id}',
                  'imgMovie':snapshot.data!.docs[index].get('imgMovie'),
                  'nameMovie':snapshot.data!.docs[index].get('nameMovie'),
                  'overview':snapshot.data!.docs[index].get('overview'),
                  'releaseDate':snapshot.data!.docs[index].get('releaseDate'),
                }));//Image.network(snapshot.data!.docs[index].get('imgMovie'));
              } ,
            );
          }else if(snapshot.hasError){
            return const Center(
              child: Text('Something was wrong')
            );
          }else{
            return const Center(
              child: CircularProgressIndicator()
            );
          }
        }
      ),
    );
  }
}