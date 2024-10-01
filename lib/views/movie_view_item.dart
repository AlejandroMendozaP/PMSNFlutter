// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_2/database/movies_database.dart';
import 'package:flutter_application_2/models/moviesdao.dart';
import 'package:flutter_application_2/settings/global_values.dart';
import 'package:flutter_application_2/views/movie_view.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MovieViewItem extends StatefulWidget {
  MovieViewItem({
    super.key,
    required this.moviesDAO,
    });
  MoviesDAO moviesDAO;

  @override
  State<MovieViewItem> createState() => _MovieViewItemState();
}

class _MovieViewItemState extends State<MovieViewItem> {

  MoviesDatabase? moviesDatabase;

  @override
  void initState() {
    super.initState();
    moviesDatabase = MoviesDatabase();
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
              Image.network('https://m.media-amazon.com/images/I/71MEh-s3p7L.jpg', height: 100,),
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
                      child: MovieView(moviesDAO: widget.moviesDAO,)
                      )
                  ],
                );
              },
              icon: Icon(Icons.edit)
            ),
            IconButton(
              onPressed: (){
                moviesDatabase!.DELETE('tblmovies', widget.moviesDAO.idMovie!).then((value){
                  if(value>0){
                    GlobalValues.banUpdateListMovies.value= !GlobalValues.banUpdateListMovies.value;
                    return QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: 'Something was wrong :(',
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