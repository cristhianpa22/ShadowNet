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
  
  final Color colorEntorno = const Color(0xFFFF9100);
  
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
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: colorEntorno,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorEntorno,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          _buildCircle(const Color(0xFFFF5F56)),
                          const SizedBox(width: 8),
                          _buildCircle(const Color(0xFFFFBD2E)),
                          const SizedBox(width: 8),
                          _buildCircle(const Color(0xFF27C93F)),
                        ],
                      ),
                    ),

                    Container(
                      height: 2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            colorEntorno,
                            colorEntorno,
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              ">> C: Windows/System32/ShadowNet/ >",
                              style: TextStyle(
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _textoMostrado,
                              style: const TextStyle(
                                color: Color(0xFFA8B0B0),
                                fontFamily: 'Courier',
                                fontSize: 14,
                              ),
                            ),
                            if (widget.distancia != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                Distancia,
                                style: TextStyle(
                                  color: colorEntorno,
                                  fontFamily: 'Courier',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Row(
              children: [
                const Text(">> ", style: TextStyle(color: Colors.greenAccent)),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    cursorColor: Colors.greenAccent,
                    style: const TextStyle(color: Color(0xFFFF9100)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Digita el codigo...",
                      hintStyle: TextStyle(color: Color(0xFFFF9100)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

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
                style: TextStyle(color: Color((0xFFFF9100))),
              ),
            ),

            const SizedBox(height: 10),

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

  Widget _buildCircle(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

}
