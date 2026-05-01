import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadownet/providers/mision_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/terminal_scren.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MisionProvider()),
      ],
      child: const ShadowNetApp(),
    ),
  );
}

class ShadowNetApp extends StatelessWidget {
  const ShadowNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // El secreto está aquí:
      home: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          if (provider.isAuthenticated) {
            return const MainTerminalScreen(); // Vista principal de misiones
          } else {
            return const AuthScreen(); // Pantalla de huella
          }
        },
      ),
    );
  }
}
