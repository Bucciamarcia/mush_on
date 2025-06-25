import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mush_on/home_page/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
// ignore: unused_import, depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/routes.dart';
import 'package:mush_on/services/auth.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/shared/dog_filter/provider.dart';
import 'package:provider/provider.dart';
import 'home_page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_screen/login_screen.dart';
import 'provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider()),
        ChangeNotifierProvider(create: (context) => DogFilterProvider())
      ],
      child: MaterialApp(
          title: 'Mush On!',
          routes: appRoutes,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
          )),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder<void>(
            future: FirestoreService().userLoginActions(),
            builder: (context, loginSnapshot) {
              if (loginSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (loginSnapshot.hasError) {
                return Center(
                  child: Text("Login action error: ${loginSnapshot.error}"),
                );
              } else {
                // Login actions completed, now check account status
                return FutureBuilder<String?>(
                  future: FirestoreService().getUserAccount(),
                  builder: (context, accountSnapshot) {
                    if (accountSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (accountSnapshot.hasError) {
                      return Center(
                        child: Text("Error: ${accountSnapshot.error}"),
                      );
                    } else {
                      // Account data loaded
                      final accountData = accountSnapshot.data;

                      if (accountData == null) {
                        return Scaffold(
                          body: Container(
                            padding: const EdgeInsets.all(10),
                            child: const SafeArea(
                              child: Text(
                                  "Access not authorized. This is normal for new accounts. The admin will authorize your account as needed."),
                            ),
                          ),
                        );
                      } else {
                        return const HomePageScreen();
                      }
                    }
                  },
                );
              }
            },
          );
        } else {
          // User is not logged in
          return const LoginScreen();
        }
      },
    );
  }
}
