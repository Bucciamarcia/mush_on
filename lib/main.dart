import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
// ignore: unused_import, depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/routes.dart';
import 'home_page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_screen/login_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  // await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  // 2. Initialize App Check
  // Use kDebugMode to determine which providers to use
  if (kDebugMode) {
    // For web debug builds, activate the debug provider.
    // For mobile (Android/iOS) debug builds, we will skip initialization.
    if (kIsWeb) {
      await FirebaseAppCheck.instance.activate(
        webProvider:
            ReCaptchaV3Provider('6LfqWvoqAAAAALSY29J39QItVs0PsyOC4liiDP_G'),
        // The appleProvider doesn't run on web, but is good to have here for completeness.
        appleProvider: AppleProvider.debug,
      );
    } else {
      // This will run for Android and iOS debug builds.
      print('--> Mobile debug build: SKIPPING App Check initialization.');
    }
  } else {
    await FirebaseAppCheck.instance.activate(
      webProvider:
          ReCaptchaV3Provider('6LfqWvoqAAAAALSY29J39QItVs0PsyOC4liiDP_G'),
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.deviceCheck,
    );
  }

  FirebaseUIAuth.configureProviders([]);

  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  tz.initializeTimeZones();
  runApp(rp.ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mush On!',
      routerConfig: goRoutes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
    );
  }
}

class HomeScreen extends rp.ConsumerWidget {
  static final BasicLogger logger = BasicLogger();
  const HomeScreen({super.key});

  Future<void> _performLoginActions(User? user) async {
    final db = FirebaseFirestore.instance;
    try {
      if (user != null) {
        try {
          var ref = db.collection("users").doc(user.uid);
          var data = {
            "lastLogin": DateTime.now().toUtc(),
            "email": user.email,
            "uid": user.uid
          };

          // Use a timeout to avoid hanging when offline
          await ref.set(data, SetOptions(merge: true)).timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('Login update timed out - likely offline');
            },
          );
        } catch (e, s) {
          if (e is TimeoutException) {
            logger.info("Login update timed out - continuing offline");
            // Don't rethrow - we can continue offline
          } else {
            logger.error("Couldn't log in", error: e, stackTrace: s);
            // Don't rethrow for offline-related errors
            if (e.toString().contains('offline') ||
                e.toString().contains('network') ||
                e.toString().contains('UNAVAILABLE')) {
              logger.info("Offline - skipping login update");
            } else {
              rethrow;
            }
          }
        }
      }
    } catch (e) {
      // Log but don't throw - we can continue offline
      logger.info('Login actions failed (likely offline): $e');
    }
  }

  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
    rp.AsyncValue<User?> userAsync = ref.watch(authStateChangesProvider);
    switch (userAsync) {
      case rp.AsyncData(:final value):
        if (value == null) {
          logger.info("Value of user is null: not logged in");
          return LoginScreen();
        } else {
          logger.info("Logging in!");
          ref.listen<rp.AsyncValue<User?>>(authStateChangesProvider,
              (previous, next) {
            final user = next.value;
            if (previous?.value == null && user != null) {
              logger.info("User logged in, performing login actions.");
              _performLoginActions(user);
            }
          });
          final userNameAsync = ref.watch(userNameProvider);
          switch (userNameAsync) {
            case rp.AsyncData(:final value):
              if (value == null) {
                logger.warning("Couldn't find an account for the user");
                return Text("Error: couldn't find an account");
              } else if (value.account == null) {
                return Text(
                    "You are not assigned to any account. This is normal for new accounts, get in touch with admin to fix.");
              } else {
                return const HomePageScreen();
              }
            case rp.AsyncError(:final error, :final stackTrace):
              logger.error("Error in fetching username",
                  error: error, stackTrace: stackTrace);
              return Text("Error: couldn't fetch the username");
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        }
      case rp.AsyncError(:final error, :final stackTrace):
        logger.error("Error in fetching user.",
            error: error, stackTrace: stackTrace);
        return Text("Unknown error occurred");
      default:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }
}
