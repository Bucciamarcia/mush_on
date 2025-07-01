import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/text_title.dart';
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

class MyApp extends rp.ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Create the future ONCE to avoid infinite loops
  late Future<void> _loginFuture;
  late Future<String?> _accountFuture;

  @override
  void initState() {
    super.initState();
    // Initialize futures once - they won't be called again on rebuilds
    _loginFuture = _performLoginActions();
    _accountFuture = _getAccount();
  }

  Future<void> _performLoginActions() async {
    try {
      await FirestoreService().userLoginActions();
    } catch (e) {
      // Log but don't throw - we can continue offline
      logger.info('Login actions failed (likely offline): $e');
    }
  }

  Future<String?> _getAccount() async {
    try {
      return await FirestoreService().getUserAccount();
    } catch (e) {
      logger.info('Failed to get account: $e');
      return null;
    }
  }

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
          // User is authenticated
          return FutureBuilder<void>(
            future: _loginFuture, // Use the cached future
            builder: (context, loginSnapshot) {
              // Don't wait for login actions - they're optional
              // Check account status immediately
              return FutureBuilder<String?>(
                future: _accountFuture, // Use the cached future
                builder: (context, accountSnapshot) {
                  if (accountSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (accountSnapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Error: ${accountSnapshot.error}"),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Recreate futures on retry
                                _loginFuture = _performLoginActions();
                                _accountFuture = _getAccount();
                              });
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Account data loaded (or null)
                    final accountData = accountSnapshot.data;

                    if (accountData == null) {
                      return Scaffold(
                        body: Container(
                          padding: const EdgeInsets.all(10),
                          child: const SafeArea(
                            child: Text(
                              "Access not authorized. This is normal for new accounts. The admin will authorize your account as needed.",
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const HomePageScreen();
                    }
                  }
                },
              );
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
