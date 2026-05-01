import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadownet/providers/mision_provider.dart';
import '../providers/auth_provider.dart';

class MainTerminalScreen extends StatelessWidget {
  const MainTerminalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final misionProvider = context.watch<MisionProvider>();

    final mision = misionProvider.misionActual;

    if (mision == null) {
      return Text("Felicidades has completado todas las misiones");
    }

    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("mision actual: ${mision['mision']}"),
          Text(provider.coordinatesDisplay, style: TextStyle(color: Colors.green),),
            Text("Distancia al nodo: ${provider.calculateDistanceToNode(4.7357055, -74.2769854).toStringAsFixed(2)} metros", style: TextStyle(color: Colors.green),),
          ElevatedButton(
            onPressed: () {
              misionProvider.CompletarMision(mision['id']);
            },
            child: Text("Marcar como completada"),
          ),


        ],
      ),
    );
  }
}
