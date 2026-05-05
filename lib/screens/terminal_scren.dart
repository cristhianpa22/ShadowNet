import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/mision_provider.dart';
import '../widgets/pistas_widget.dart';

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
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: Color.fromARGB(255, 202, 141, 224), size: 80),
              SizedBox(height: 20),
              Text(
                "MISION COMPLETADA\nERES EL DUEÑO DEL SENA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 206, 163, 222), 
                  fontFamily: 'Courier', 
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      );
    }

    double distancia = misionProvider.distanciaActual;
    bool enRangoMision = distancia <= mision['distancia_mision'];
    Color colorSistema = Color(0xC476FBFB);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ROOT@SHADOWNET:~#", 
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 10, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(
                        mision['titulo'].toString().toUpperCase(), 
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 14, 
                          fontFamily: 'Courier'
                        )
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorSistema),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      enRangoMision ? "SIGNAL: BREACHING" : "LINK: STABLE", 
                      style: TextStyle(
                        color: colorSistema, 
                        fontSize: 9, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                  )
                ],
              ),
            ),

            const Divider(color: Color(0xFF1A1A1A), thickness: 2, height: 2),

            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: colorSistema, width: 1),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(color: colorSistema, blurRadius: 5, spreadRadius: 2),
                  ],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Estado:", style: TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'Courier')),
                              Text("${authProvider.coordinatesDisplay}", style: TextStyle(color: colorSistema, fontSize: 10, fontFamily: 'Courier')),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text("Mision Actual: ", style: TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'Courier')),
                              Text("${mision['titulo']}", style: TextStyle(color: colorSistema, fontSize: 10, fontFamily: 'Courier')),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          Expanded(
                            child: TerminalMisionWidget(
                              texto: enRangoMision ? mision['objetivo_final'] : mision['pista'],
                              titulo: mision['titulo'],
                              icono: enRangoMision ? Icons.gps_fixed : Icons.radar,
                              color: colorSistema,
                              distancia: "DISTANCE_TO_NODE: ${distancia.toStringAsFixed(1)}m",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF0F0F0F),
                border: Border(top: BorderSide(color: Color(0xFF1A1A1A), width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("COORD_X_Y", style: TextStyle(color: Colors.grey, fontSize: 8)),
                      Text(
                        authProvider.coordinatesDisplay.split(':').last.trim(), 
                        style: TextStyle(
                          color: colorSistema, 
                          fontSize: 10, 
                          fontFamily: 'Courier'
                        )
                      ),
                    ],
                  ),

                  Icon(Icons.fingerprint, color: colorSistema, size: 24),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "SYS_STATUS", 
                        style: TextStyle(
                          color: Colors.grey, 
                          fontSize: 8
                        )
                      ),
                      Text(
                        enRangoMision ? "OVERRIDE" : "SCANNING", 
                        style: TextStyle(
                          color: colorSistema, 
                          fontSize: 10, 
                          fontFamily: 'Courier'
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}