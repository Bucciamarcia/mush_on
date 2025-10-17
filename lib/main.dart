import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/username.dart';
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
import 'package:url_strategy/url_strategy.dart';

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
  await FirebaseAppCheck.instance.activate(
      webProvider:
          ReCaptchaV3Provider("6LfqWvoqAAAAALSY29J39QItVs0PsyOC4liiDP_G"),
      androidProvider: AndroidProvider.debug);
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
  setPathUrlStrategy();
  runApp(const rp.ProviderScope(child: MyApp()));
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

  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
    rp.AsyncValue<User?> userAsync = ref.watch(userProvider);
    return userAsync.when(
        data: (user) {
          if (user == null) {
            return const LoginScreen();
          } else {
            logger.info("Logging in!");
            final userNameAsync = ref.watch(userNameProvider(null));
            return userNameAsync.when(
              data: (userName) {
                if (userName == null) {
                  final ref =
                      FirebaseFirestore.instance.doc("users/${user.uid}");
                  ref.set(
                    UserName(
                      uid: user.uid,
                      email: user.email ?? "",
                      account: null,
                      lastLogin: DateTime.now(),
                    ).toJson(),
                  );
                  return const Text("Creating user");
                } else if (userName.account == null) {
                  return const Text(
                      "You are not assigned to any account. This is normal for new accounts, get in touch with admin to fix.");
                } else {
                  return const HomePageScreen();
                }
              },
              error: (e, s) {
                logger.error("Error in fetching username",
                    error: e, stackTrace: s);
                return Text("Error: $e");
              },
              loading: () => const CircularProgressIndicator.adaptive(),
            );
          }
        },
        error: (e, s) {
          logger.error("Error in authStateChangesProvider",
              error: e, stackTrace: s);
          return Center(
            child: Text("Error: $e"),
          );
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}
