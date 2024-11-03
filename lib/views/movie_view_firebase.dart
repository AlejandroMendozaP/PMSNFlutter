import 'package:flutter/material.dart';
import 'package:flutter_application_2/database/movies_database.dart';
import 'package:flutter_application_2/firebase/database_movies.dart';
import 'package:flutter_application_2/models/moviesdao.dart';
import 'package:flutter_application_2/settings/global_values.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class MovieViewFirebase extends StatefulWidget {
  MovieViewFirebase({super.key, this.moviesDAO});

  MoviesDAO? moviesDAO;

  @override
  State<MovieViewFirebase> createState() => _MovieVewState();
}

class _MovieVewState extends State<MovieViewFirebase> {

  TextEditingController conName = TextEditingController();
  TextEditingController conOverview = TextEditingController();
  TextEditingController conImgMovie = TextEditingController();
  TextEditingController conRelease = TextEditingController();

  DatabaseMovies? databaseMovies;

  @override
  void initState() {
    super.initState();
    databaseMovies = DatabaseMovies();

    if(widget.moviesDAO!=null){
      conName.text = widget.moviesDAO!.nameMovie!;
      conOverview.text = widget.moviesDAO!.overview!;
      conImgMovie.text = widget.moviesDAO!.imgMovie!;
      conRelease.text = widget.moviesDAO!.releaseDate!;
    }
  }

  @override
  Widget build(BuildContext context) {

    final txtNameMovie = TextFormField(
      controller: conName,
      decoration: const InputDecoration(hintText: 'Nombre de la pelicula'),
    );
    final txtOverview = TextFormField(
      controller: conOverview,
      decoration: const InputDecoration(hintText: 'Sinopsis de la pelicula'),
      maxLines: 5,
    );
    final txtImgMovie = TextFormField(
      controller: conImgMovie,
      decoration: const InputDecoration(hintText: 'Poster de la pelicula'),
    );
    final txtRelease = TextFormField(
      readOnly: true,
      controller: conRelease,
      decoration: const InputDecoration(hintText: 'Fecha de lanzamiento'),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2030)
        );

        if(pickedDate != null){
          String formatDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          conRelease.text = formatDate;
          setState(() {});
        }
      },
    );

    final btnSave = ElevatedButton(
      onPressed: (){
        if(widget.moviesDAO == null){
            databaseMovies!.insert({
            "nameMovie" : conName.text,
            "overview" : conOverview.text,
            "imgMovie" : conImgMovie.text,
            "releaseDate" : conRelease.text
          }).then((value){
            if(value){
              return QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Transaction Completed Successfully!',
                autoCloseDuration: const Duration(seconds: 2),
                showConfirmBtn: false,
              );
            }else{
              return QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Something was wrong :(',
                autoCloseDuration: const Duration(seconds: 2),
                showConfirmBtn: false,
              );
            }
          });
        }/*else{
          databaseMovies!.update({
            "idMovie" : widget.moviesDAO!.idMovie,
            "nameMovie" : conName.text,
            "overview" : conOverview.text,
            "imgMovie" : conImgMovie.text,
            "releaseDate" : conRelease.text
          }).then((value){
            QuickAlertType type = QuickAlertType.success;
            final msj;
            if(value>0){
              GlobalValues.banUpdateListMovies.value = !GlobalValues.banUpdateListMovies.value;
              type = QuickAlertType.success;
              msj = "Transaccion completa";
            }else{
              type = QuickAlertType.error;
              msj = "Something was wrong :(";
            }
            return QuickAlert.show(
                context: context,
                type: type,
                text: msj,
                autoCloseDuration: const Duration(seconds: 2),
                showConfirmBtn: false,);
          });
        }*/
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
      child: const Text('Guardar'),
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      children: [
        txtNameMovie,
        txtOverview,
        txtImgMovie,
        txtRelease,
        btnSave
      ],
    );
  }
}