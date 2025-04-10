import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BasicLogger {
  // Keep logger instance
  final Logger logger = Logger(
    // Optional: Configure logger further if needed (printers, etc.)
    printer: PrettyPrinter(
      methodCount: 1, // Display fewer methods in stack trace for console
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  // Trace, Debug, Info, Warning remain the same (only log if kDebugMode)
  void trace(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      // Using just kDebugMode is more idiomatic
      logger.t(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  void debug(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      logger.d(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  void info(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      logger.i(message, time: time, error: error, stackTrace: stackTrace);
    } else {
      FirebaseCrashlytics.instance.log(message);
    }
  }

  void warning(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      logger.w(message, time: time, error: error, stackTrace: stackTrace);
    } else {
      FirebaseCrashlytics.instance.log("WARNING: $message");
    }
  }

  void error(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      logger.e(message, time: time, error: error, stackTrace: stackTrace);
    } else {
      if (error != null) {
        FirebaseCrashlytics.instance.recordError(
          error, // Pass the actual error object here
          stackTrace, // Pass the stack trace here
          reason: message, // Use your message string as the reason/context
          fatal: false, // Mark as non-fatal
        );
      } else {
        FirebaseCrashlytics.instance
            .log('Non-fatal error reported without exception object: $message');
      }
    }
  }

  void fatal(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      logger.f(message, time: time, error: error, stackTrace: stackTrace);
    } else {
      // Only record if there's an actual error object provided
      if (error != null) {
        FirebaseCrashlytics.instance.recordError(
          error, // Pass the actual error object here
          stackTrace, // Pass the stack trace here
          reason: message, // Use your message string as the reason/context
          fatal: true, // Mark as fatal
        );
      } else {
        FirebaseCrashlytics.instance
            .log('Fatal error reported without exception object: $message');
      }
    }
  }
}

class ErrorSnackbar extends SnackBar {
  final String message;

  ErrorSnackbar(this.message, {super.key})
      : super(
          backgroundColor: Colors.red,
          content: Text(message),
        );
}
