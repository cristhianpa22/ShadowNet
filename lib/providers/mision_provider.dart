import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

class MisionProvider extends ChangeNotifier{
  List<dynamic> getOption = [];

  String _mensajeError = "";

  String get mensajeError => _mensajeError;

  MisionProvider(){
    loadData();
  }

  dynamic get misionActual{
    if(getOption.isEmpty)return null;

    return getOption.firstWhere(
      (m)=>m['completada']== false,orElse: () => null,
    );
  }



  Future<void> loadData() async{
    try {
      final String value = await rootBundle.loadString('data/mision.json');
      final Map<String, dynamic> datos = json.decode(value);

      getOption = datos["misiones"]; 

      notifyListeners();
    } catch (e) {
      print("Error cargando el JSON: $e");
    }
  }
  double _distanciaActual = 9999;
  double get distanciaActual => _distanciaActual;

  void completarMision({required double latitud, required double longitud, String? codigoSecreto}){
    final mision = misionActual;

    if(mision == null){
      _mensajeError = "No hay misiones disponibles";
      notifyListeners();
      return;
    }
    _distanciaActual = Geolocator.distanceBetween(
      latitud, 
      longitud, 
      mision['latitud'], 
      mision['longitud']);
    

    if(codigoSecreto != mision['codigo_secreto']){
      _mensajeError = "Codigo secreto incorrecto";
      notifyListeners();
      return;
    }
    mision['completada'] = true;
    _mensajeError = "Mision completada correctamente";
    notifyListeners();
  }
}



