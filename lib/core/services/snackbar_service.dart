import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final snackbarServiceProvider = Provider((ref) => SnackbarService());

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> _key =
      GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<ScaffoldMessengerState> get key => _key;

  void showError(String message) {
    _key.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showSuccess(String message) {
    _key.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showInfo(String message) {
    _key.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
