// Mock error reporting for services like Sentry or Firebase Crashlytics
import 'package:flutter/foundation.dart';

void reportError({
  dynamic error,
  dynamic stackTrace,
  Map<String, dynamic>? extra,
}) {
  if (kDebugMode) {
    print('Error = $error');
    print('Stacktrace = $stackTrace');
    print('Extra = $extra');
  }
}
