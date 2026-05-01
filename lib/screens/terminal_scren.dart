import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadownet/providers/mision_provider.dart';
import '../providers/auth_provider.dart';

class MainTerminalScreen extends StatelessWidget {
  const MainTerminalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final misionProvider = context.watch<MisionProvider>();
    final authProvider = context.watch<AuthProvider>();

    final mision = misionProvider.misionActual;

    if (authProvider.currentPosition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        misionProvider.actualizarSeguimiento(authProvider.currentPosition!);
      });
    }

    if (mision == null) {
      return Text("Felicidades has completado todas las misiones");
    }

    //final provider = Provider.of<AuthProvider>(context);

    double distancia = misionProvider.distanciaActual;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Estado ${authProvider.coordinatesDisplay}"),
            Text("Mision actual: ${mision['titulo']}"),
            Divider(),

            if (distancia <= mision['distancia_mision'])
              Column(
                children: [
                  Icon(Icons.location_on, size: 50, color: Colors.green),
                  Text(
                    "!Mision final!",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(mision['objetivo_final']),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Introduce el codigo secreto",
                    ),
                    onSubmitted: (value) => misionProvider.completarMision(
                      codigoSecreto: value,
                    ),
                    
                  ),
                  if(misionProvider.mensajeError != null) ...[
                    Text(
                      misionProvider.mensajeError,
                      style: TextStyle(
                        color: Colors.red ,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Courier',
                        fontSize: 17,
                      ),
                    ),
                  ],
                ],
              )
            else if (distancia <= mision['distancia_pista'])
              Column(
                children: [
                  Icon(Icons.search, size: 50, color: Colors.green),
                  Text(
                    "!Pista desbloqueada!",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(mision['pista'], textAlign: TextAlign.center),
                  ),
                  Text(
                    "Acerctae mas para la mision final (faltan: ${distancia.toStringAsFixed(1)} metros)",
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
