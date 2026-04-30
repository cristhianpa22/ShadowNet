import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user, color: Color(0xFF00FF41)),
                SizedBox(width: 10),
                Text(
                  "VERIFICAR DNI REQUERIDO",
                  style: TextStyle(
                    color: Color(0xFF00FF41),
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 1,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00FF41), width: 2),
              ),
            ),
          ],
        ),

        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFba8501), width: 2),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 0, 66, 17),
                      width: 4,
                    ),
                    color: const Color(0xFF122412),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 180,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF324d32),
                                width: 1,
                              ),
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                            child: IconButton(
                              onPressed: () => provider.isSelfDestructActive
                                  ? null
                                  : provider.authenticateOperator(),
                              icon: provider.isSelfDestructActive
                                  ? const Icon(
                                      Icons.lock,
                                      size: 130,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.fingerprint,
                                      size: 100,
                                      color: Color(0xFF818466),
                                    ),
                            ),
                          ),
                          if (!provider.isSelfDestructActive)
                            const ScanningLine(),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "OPERADOR_ID: ",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Courier',
                    fontSize: 17,
                  ),
                ),
                provider.isSelfDestructActive
                    ? Text(
                        "!!! ACCESO BLOQUEADO !!!",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier',
                          fontSize: 17,
                        ),
                      )
                    : Row(
                        children: [
                          Text(
                            "OX8F4",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Courier',
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            "  ESCANEANDO....",
                            style: TextStyle(
                              color: const Color(0xFF966c01),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Courier',
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            const SizedBox(height: 20),
            if (provider.isSelfDestructActive)
              TweenAnimationBuilder<double>(
                key: ValueKey(provider.isSelfDestructActive),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 5),
                builder: (context, value, child) {
                  return Container(
                    width: 250,
                    height: 30,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121611),
                      border: Border.all(
                        color: const Color(0xFF00b92f),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00b92f).withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 250 * value,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00c331),

                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(
                                255,
                                137,
                                184,
                                71,
                              ).withValues(),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 40),
            if (provider.isSelfDestructActive)
              const Text(
                "PROTOCOLO DE AUTODESTRUCCIÓN INICIADO",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            if (!provider.isSelfDestructActive)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.green,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    ">  ACCEDIENDO A LA RED ",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "> ENCRIPTANDO DATOS ",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    ">  ESPERANDO AUTORIZACION ",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "BIOMETRIA ...",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                      fontSize: 17,
                    ),
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

class ScanningLine extends StatefulWidget {
  const ScanningLine({super.key});

  @override
  State<ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<ScanningLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top:
              10 +
              (_controller.value * 180), // Mueve la línea de arriba a abajo
          child: Container(
            width: 170,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.orange,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
