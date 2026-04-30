import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vibration/vibration.dart';

class AuthProvider extends ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isAuthenticated = false;
  bool _isSelfDestructActive = false;
  int _authAttempts = 0;
  Position? _currentPosition;

  bool get isAuthenticated => _isAuthenticated;
  bool get isSelfDestructActive => _isSelfDestructActive;
  Position? get currentPosition => _currentPosition;

  Future<void> authenticateOperator() async {
    try {
      bool success = await _auth.authenticate(
        localizedReason: 'Valida que tu ADN es humano',
      );

      if (success) {
        _isAuthenticated = true;
        _authAttempts = 0;
      } else {
        _errorAutentication();
      }
    } catch (e) {
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

  void updateLocation(Position position) {
    _currentPosition = position;
    notifyListeners();
  }

  double calculateDistanceToNode(double nodeLat, double nodeLng) {
    if (_currentPosition == null) return 9999;
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      nodeLat,
      nodeLng,
    );
  }
}
