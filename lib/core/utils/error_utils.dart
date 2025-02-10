import 'dart:developer';
import '../network/api_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/app_toast.dart';

class ErrorUtils {
  static String getErrorMessage(Object error) {
    if (error is String) return error;

    return error.toString();
  }

  static void showError(WidgetRef ref, Object error) {
    ref.read(toastProvider.notifier).state = getErrorMessage(error);
  }

  static bool isNetworkError(Object error) {
    return error.toString().toLowerCase().contains('network');
  }

  static bool isAuthError(Object error) {
    return error is UnauthorizedException;
  }
}
