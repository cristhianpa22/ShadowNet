import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadownet/providers/mision_provider.dart';

class TerminalMisionWidget extends StatefulWidget {
  final String texto;
  final String titulo;
  final IconData icono;
  final Color color;

  final String? distancia;

const TerminalMisionWidget ({
    super.key, 
    required this.texto,
    required this.titulo, 
    required this.icono,
    required this.color,
    this.distancia
});

  @override
  State<TerminalMisionWidget> createState() => _TerminalMisionWidgetState();
}

class _TerminalMisionWidgetState extends State<TerminalMisionWidget> {
  final TextEditingController _controller = TextEditingController();



  String _textoMostrado = "";
  String _ultimoTexto = "";
  String Titulo ="";
  String Distancia = "";
  Timer? _timer;

  void _escribirTexto(String texto, String titulo, String distancia) {
    _textoMostrado = "";
    _timer?.cancel();

    int i = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (i < texto.length) {
        setState(() {
          _textoMostrado += texto[i];
          Titulo += titulo[i];
          Distancia += distancia[i];
        });
        i++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final misionProvider = Provider.of<MisionProvider>(context);
    final mision = misionProvider.misionActual;

    String textoTerminal = "";

    if (mision == null) {
      textoTerminal = ">> No hay misiones disponibles...";
    }

    // Evita que se ejecute mil veces
    if (_ultimoTexto != textoTerminal) {
      _ultimoTexto = textoTerminal;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _escribirTexto(
          widget.texto,
          widget.titulo,
          widget.distancia ?? "",
        );
      });
    }

    return Material(
      color: Colors.black,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///  TERMINAL (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    
                    Text(
                      ">> C: Windows/System32/ShadowNet/ >",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 209, 134, 218),
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      Titulo,
                      style: const TextStyle(
                        color: widget.color,
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _textoMostrado,
                      style: const TextStyle(
                        color: widget.color,
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                    ),

                    if (widget.distancia != null)
                    Text(
                      Distancia,
                      style: const TextStyle(
                        color: widget.color,
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ⌨️ INPUT
            Row(
              children: [
                const Text(">> ", style: TextStyle(color: Colors.greenAccent)),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    cursorColor: Colors.greenAccent,
                    style: const TextStyle(color: Colors.greenAccent),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Escribe código...",
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔘 BOTÓN
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                side: const BorderSide(color: Colors.greenAccent),
              ),
              onPressed: () {
                misionProvider.completarMision(
                  codigoSecreto: _controller.text.trim(),
                );
                _controller.clear();
              },
              child: const Text(
                "Ejecutar",
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),

            const SizedBox(height: 10),

            /// 📢 MENSAJE DEL SISTEMA
            Text(
              misionProvider.mensajeError,
              style: TextStyle(
                color: misionProvider.mensajeError.contains("correctamente")
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
