import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadownet/providers/mision_provider.dart';

class TerminalMisionWidget extends StatefulWidget {
  const TerminalMisionWidget({super.key});

  @override
  State<TerminalMisionWidget> createState() => _TerminalMisionWidgetState();
}

class _TerminalMisionWidgetState extends State<TerminalMisionWidget> {
  final TextEditingController _controller = TextEditingController();

  String _textoMostrado = "";
  String _ultimoTexto = "";
  Timer? _timer;

  void _escribirTexto(String texto) {
    _textoMostrado = "";
    _timer?.cancel();

    int i = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (i < texto.length) {
        setState(() {
          _textoMostrado += texto[i];
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
    } else {
      textoTerminal = """
>> Inicializando sistema...
>> Cargando misión...

[OBJETIVO]
${mision['descripcion']}

[PISTA]
${mision['pista']}

[DISTANCIA]
${misionProvider.distanciaActual.toStringAsFixed(2)} metros

>> Ingresa el código secreto:
""";
    }

    // 🔥 Evita que se ejecute mil veces
    if (_ultimoTexto != textoTerminal) {
      _ultimoTexto = textoTerminal;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _escribirTexto(textoTerminal);
      });
    }

    return Material(
      color: Colors.black,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖥️ TERMINAL (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _textoMostrado,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'Courier',
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            /// ⌨️ INPUT
            Row(
              children: [
                const Text(
                  ">> ",
                  style: TextStyle(color: Colors.greenAccent),
                ),
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