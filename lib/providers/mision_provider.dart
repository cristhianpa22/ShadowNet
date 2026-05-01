import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:vibration/vibration.dart';

class MisionProvider extends ChangeNotifier{
  List<dynamic> getOption = [];

  String _mensajeError = "";
  bool _isVibrating = false;

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

  void actualizarSeguimiento(Position position) async {
    final mision = misionActual;
    if (mision == null) return;

    _distanciaActual = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      mision['latitud'],
      mision['longitud'],
    );
    if (await Vibration.hasVibrator() ?? false) {
      if (_distanciaActual <= 10) {
        if (!_isVibrating) {
          _isVibrating = true;
          Vibration.vibrate(pattern: [100, 200, 100, 200, 100, 200, 400, 400]);
          Future.delayed(const Duration(seconds: 5), () {
            _isVibrating = false;
          });
        }
      }
      else {
        if (_isVibrating) {
          Vibration.cancel();
          _isVibrating = false;
        }
      }
    }
    notifyListeners();
  }

  void completarMision({String? codigoSecreto}){
    final mision = misionActual;

    if(mision == null){
      _mensajeError = "No hay misiones disponibles";
      notifyListeners();
      return;
    }
    
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



