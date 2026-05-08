import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'terminal_scren.dart';

class ContextoScreen extends StatefulWidget {
  final bool esIntro;

  const ContextoScreen({super.key, this.esIntro = true});

  @override
  State<ContextoScreen> createState() => _ContextoScreenState();
}

class _ContextoScreenState extends State<ContextoScreen> with TickerProviderStateMixin {
  late int _currentStep;
  late List<String> _guiones;
  String _displayedText = "";
  Timer? _typewriterTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    if (widget.esIntro) {
      _currentStep = 0;
      _guiones = [
        "Upss... parece que alguien ha interceptado la base de datos.",
        "Si estás leyendo esto, es porque tu firma genética ha sido validada.",
        "La IA central ha bloqueado el acceso al SENA Mosquera.",
        "Para recuperar el control, necesitamos infiltrarnos físicamente en los nodos.",
        "Tu terminal ha detectado 4 puntos de acceso. ¡No hay vuelta atrás!",
        "Deberás descifrar las pistas y moverte físicamente por el sector.",
        "Al llegar a una zona segura, el terminal revelará un fragmento del código.",
      ];
    } 
    _startTypewriter(_guiones[_currentStep]);
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    super.dispose();
  }

  void _startTypewriter(String text) {
    _typewriterTimer?.cancel();
    _displayedText = "";
    _isTyping = true;
    int charIndex = 0;
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (charIndex < text.length) {
        setState(() {
          _displayedText += text[charIndex];
          charIndex++;
        });
      } else {
        setState(() => _isTyping = false);
        timer.cancel();
      }
    });
  }

  void _nextStep() {
    if (_isTyping) {
      _typewriterTimer?.cancel();
      setState(() {
        _displayedText = _guiones[_currentStep];
        _isTyping = false;
      });
      return;
    }

    if (_currentStep < _guiones.length - 1) {
      setState(() {
        _currentStep++;
        _startTypewriter(_guiones[_currentStep]);
      });
    } else {
      if (widget.esIntro) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  MainTerminalScreen()),
        );
      } else {
      _currentStep = 0;
      _guiones = [
        "Conexión Establecida.\n\nEncriptacion rota. Eres oficialmente el dueño del nodo SENA.\n\nBienvenido."
      ];
    }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    const Color azulito = Color(0xFF76FBFB);
    const Color morado = Color(0xFFBC00FF);
    const Color naranja = Color(0xFFFF9100);
    const Color fondo = Color(0xFF111419);
    const Color mintverde = Color(0xFF87CF3E);

    return Scaffold(
      backgroundColor: fondo,
      body: GestureDetector(
        onTap: _nextStep,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(shape: BoxShape.circle, color: azulito.withAlpha(30)),
              ),
            ),
            Positioned(
              bottom: 0,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(shape: BoxShape.circle, color: morado.withAlpha(40)),
              ),
            ),
            Positioned(
              top: 200,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(shape: BoxShape.circle, color: naranja.withAlpha(25)),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(color: Colors.transparent),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "ALERTA DE HACKEO!!",
                          style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    
                    Center(
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: Text(
                              '''
                                            ...-::::::::::::::-...
                                      .-MMMM`..:MMMMMMMMMMMMM:..`MMMM-.
                                    .:MMMMM.:MMMMMMMMMMMMMMMMMM:.MMMMM:.
                                    -MMM-M---MMMMMMMMMMMMMMMMMMMMMM.MMMMM-
                                   :MM:M`  :MMMM:........::-....-MMMM-MMM:`
                                  -MMM:M`   :MM:`    ``      ``   `:MMMM:MM:
                                  -MMMMM    :MM:    -MM-    -MM-  `:MMMM:MM.
                                  -MMMMM    :MM:    -MM-    -MM-  `:MMMM:MM:
                                  -MMMMM    :MM:    -MM-    -MM-  `:MMMM:MM:
                                  -MMMMM    :MM:    -MM-    -MM-  `:MMMM:MM:
                                  -MMMMM    :MM:    -MM-    -MM-  `:MMMM:MM.
                                   +MMMMM   :MM:---:MMM:----:MM-  -MMMM:MM:
                                   +MMMMM      +MMM
                                   +MMMMM              +MMM
                                    +MMMMm--------------MMMM
                                     ./MMMMMMMMMMMMMMMMMMM.
                                        .---:////////:---.
                                        ''',
                              style: TextStyle(
                                color: mintverde,
                                fontFamily: 'Courier',
                                fontSize: 8,
                                height: 1.1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0x1AFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withAlpha(30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.terminal_rounded, color: morado, size: 30),
                          const SizedBox(height: 20),
                          Text(
                            _displayedText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Courier',
                              fontSize: 19,
                              height: 1.5,
                            ),
                          ),
                          if (!_isTyping)
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              width: 10,
                              height: 20,
                              color: azulito,
                            ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "TOCA PARA CONTINUAR",
                            style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _guiones.length,
                              (i) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: i == _currentStep ? 18 : 6,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: i == _currentStep ? azulito : Colors.white24,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
