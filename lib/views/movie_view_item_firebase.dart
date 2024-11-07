// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_2/firebase/database_movies.dart';
import 'package:flutter_application_2/models/moviesdao.dart';
import 'package:flutter_application_2/views/movie_view_firebase.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MovieViewItemFirebase extends StatefulWidget {
  MovieViewItemFirebase({
    super.key,
    required this.moviesDAO,
    required this.Uid
    });
  MoviesDAO moviesDAO;
  final Uid;

  @override
  State<MovieViewItemFirebase> createState() => _MovieViewItemFirebaseState();
}

class _MovieViewItemFirebaseState extends State<MovieViewItemFirebase> {

  DatabaseMovies? moviesDatabase;

  @override
  void initState() {
    super.initState();
    moviesDatabase = DatabaseMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:Colors.blueAccent
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(widget.moviesDAO.imgMovie!),
              Expanded(
                child: ListTile(
                  title: Text(widget.moviesDAO.nameMovie!),
                  subtitle: Text(widget.moviesDAO.releaseDate!),
              )
            ),
            IconButton(
              onPressed: (){
                WoltModalSheet.show(
                  context: context,
                  pageListBuilder: (context) => [
                    WoltModalSheetPage(
                      child: MovieViewFirebase(moviesDAO: widget.moviesDAO, Uid: widget.Uid)
                      )
                  ],
                );
              },
              icon: Icon(Icons.edit)
            ),
            IconButton(
              onPressed: (){
                moviesDatabase!.delete(widget.Uid).then((value){
                  if(value){
                    return QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Ok ;)',
                      autoCloseDuration: const Duration(seconds: 2),
                      showConfirmBtn: false,
                    );
                  }
                  else{
                    return QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: 'Something was wrong :(',
                      autoCloseDuration: const Duration(seconds: 2),
                      showConfirmBtn: false,
                    );
                  }
                });
              },
              icon: Icon(Icons.delete)
            )
            ],
          ),
          const Divider(),
          Text(widget.moviesDAO.overview!),
        ],
      ),
    );
  }
}