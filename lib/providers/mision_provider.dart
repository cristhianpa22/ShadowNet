import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class MisionProvider extends ChangeNotifier{
  List<dynamic> getOption = [];

  String _mensajeError = "";

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

  void CompletarMision(int id){
  final index = getOption.indexWhere((m)=>m['id']==id);

  if(index != -1){
    getOption[index]['completada'] = true;

    notifyListeners();
  }
}


}
