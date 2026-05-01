import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class MainTerminalScreen extends StatelessWidget {
  const MainTerminalScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(provider.coordinatesDisplay, style: TextStyle(color: Colors.green),),
            Text("Distancia al nodo: ${provider.calculateDistanceToNode(4.7357055, -74.2769854).toStringAsFixed(2)} metros", style: TextStyle(color: Colors.green),),
          ],
        ),
      ),
    );
  }
}