import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadownet/providers/mision_provider.dart';
import '../providers/auth_provider.dart';
import 'package:shadownet/widgets/pistas_widget.dart';

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
            Expanded(child: TerminalMisionWidget(texto: mision['objetivo_final'], titulo:mision['titulo'], icono: Icons.location_on, color: Colors.red,distancia:authProvider.coordinatesDisplay,)
            )
             
               
                  // if(misionProvider.mensajeError != null) ...[
                  //   Text(
                  //     misionProvider.mensajeError,
                  //     style: TextStyle(
                  //       color: Colors.red ,
                  //       fontWeight: FontWeight.bold,
                  //       fontFamily: 'Courier',
                  //       fontSize: 17,
                  //     ),
                  //   ),
                  // ],
            else if (distancia <= mision['distancia_pista'])
              Expanded(
                child: TerminalMisionWidget(
                  texto: mision['pista'],
                  titulo: mision['titulo'],
                  icono: Icons.warning,
                  color: Colors.yellow,
                  distancia: "Distancia a la misión: ${distancia.toStringAsFixed(2)} metros",
                ),
              ),
          ],
        ),
      ),
    );
  }
}