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

  const TerminalMisionWidget({
    super.key,
    required this.texto,
    required this.titulo,
    required this.icono,
    required this.color,
    this.distancia,
  });

  @override
  State<TerminalMisionWidget> createState() => _TerminalMisionWidgetState();
}

class _TerminalMisionWidgetState extends State<TerminalMisionWidget> {
  final TextEditingController _controller = TextEditingController();

  String _textoMostrado = "";
  String _ultimoTexto = "";
  String Titulo = "";
  String Distancia = "";
  Timer? _timer;

  void _escribirTexto(String texto, String titulo, String distancia) {
    _textoMostrado = "";
    Titulo = "";
    Distancia = "";
    _timer?.cancel();

    int i = 0;
    int j = 0;
    int k = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (j >= titulo.length && i >= texto.length && k >= distancia.length) {
        timer.cancel();
        return;
      }
      setState(() {
        if (j < titulo.length) {
          Titulo += titulo[j++];
        } else if (i < texto.length) {
          _textoMostrado += texto[i++];
        } else if (k < distancia.length) {
          Distancia += distancia[k++];
        }
      });
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

    final clave = '${widget.texto}|${widget.titulo}|${widget.distancia}';

    // Evita que se ejecute mil veces
    if (_ultimoTexto != clave) {
      _ultimoTexto = clave;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _escribirTexto(widget.texto, widget.titulo, widget.distancia ?? "");
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
                      style: TextStyle(
                        color: widget.color,
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _textoMostrado,
                      style: TextStyle(
                        color: widget.color,
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                    ),


                    if (widget.distancia != null)
                      Text(
                        Distancia,
                        style: TextStyle(
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
