import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vibration/vibration.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class AuthProvider extends ChangeNotifier {
  static const MethodChannel _biometricChannel =
    MethodChannel('shadownet/biometric');
  

  bool _isAuthenticated = false;
  bool _isSelfDestructActive = false;
  int _authAttempts = 0;
  String _coordinatesDisplay = "ESPERANDO SEÑAL...";
  Position? _currentPosition;

  bool get isAuthenticated => _isAuthenticated;
  bool get isSelfDestructActive => _isSelfDestructActive;
  Position? get currentPosition => _currentPosition;
  String get coordinatesDisplay => _coordinatesDisplay;

  Future<void> authenticateOperator() async {
  if (_isSelfDestructActive) return;

  try {
    if (!Platform.isAndroid) {
      // Si quieres, aquí dejas fallback para iOS
      _errorAutentication();
      notifyListeners();
      return;
    }

    final Map<dynamic, dynamic>? res =
        await _biometricChannel.invokeMethod<Map<dynamic, dynamic>>(
      'startBiometric',
    );

    final status = res?['status'] as String?;

    if (status == 'success') {
      _isAuthenticated = true;
      _authAttempts = 0;
      await activateTracking();
    } else if (status == 'locked') {
      // 3 fallos sin cerrar manualmente el prompt
      _authAttempts = 3;
      _triggerSelfDestruct(); // tu error actual de auth_screen se mostrará
    } else {
      // "error": cancelación, cierre por sistema, etc.
      // Si NO quieres contar cancelaciones, no sumes aquí.
      // _errorAutentication();
    }
  } on PlatformException {
    _errorAutentication();
  } catch (_) {
    _errorAutentication();
  }

  notifyListeners();
}

  void _errorAutentication() {
    _authAttempts++;
    if (_authAttempts >= 3) {
      _triggerSelfDestruct();
    }
  }

  void _triggerSelfDestruct() async {
    _isSelfDestructActive = true;
    notifyListeners();

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 5000, amplitude: 255);
    }
    await Future.delayed(const Duration(seconds: 5));
    _isSelfDestructActive = false;
    _authAttempts = 0;
    notifyListeners();
  }

  Future<void> activateTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return; 
    }

    if (permission == LocationPermission.deniedForever)
      return; 

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1
      ),
    ).listen((Position position) {
      _coordinatesDisplay =
          "LAT: ${position.latitude.toStringAsFixed(4)} | LNG: ${position.longitude.toStringAsFixed(4)}";

      _currentPosition = position;
      notifyListeners();

      print(
        "Ubicación actualizada: ${position.latitude}, ${position.longitude}",
      );
    });
  }
}