import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:mush_on/resellers/home/home.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/services/models/username.dart';
import 'package:mush_on/shared/text_title.dart';
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
  // Emulators
  if (kDebugMode) {
    try {
      // Determine the correct host based on platform
      String host;
      if (defaultTargetPlatform == TargetPlatform.android) {
        host = 'localhost'; // Android emulator
      } else {
        host = 'localhost'; // iOS simulator, web, etc.
      }

      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);

      print('Connected to emulators: $host');
    } catch (e) {
      print('Emulator connection error: $e');
    }
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
      if (!kDebugMode) // Only add Google in production
        GoogleProvider(
            clientId:
                "337862523976-bam0ptripclqt2fdvajqgg3bsm8qqaqh.apps.googleusercontent.com"),
    ]);
  } else {
    FirebaseUIAuth.configureProviders([
      GoogleProvider(
          clientId:
              "337862523976-bam0ptripclqt2fdvajqgg3bsm8qqaqh.apps.googleusercontent.com"),
    ]);
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

class CreateKennelTextAndButton extends StatefulWidget {
  final UserName userName;
  const CreateKennelTextAndButton({super.key, required this.userName});

  @override
  State<CreateKennelTextAndButton> createState() =>
      _CreateKennelTextAndButtonState();
}

class _CreateKennelTextAndButtonState extends State<CreateKennelTextAndButton> {
  late TextEditingController _controller;
  late bool _isUpdating;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isUpdating = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isUpdating) return const CircularProgressIndicator.adaptive();
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hint: Text("Kennel name")),
        ),
        ElevatedButton(
            onPressed: () async {
              setState(() {
                _isUpdating = true;
              });
              if (_controller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    errorSnackBar(context, "The name must not be empty"));
                setState(() {
                  _isUpdating = false;
                });
                return;
              }
              var value = _controller.text;
              value = value.trim();
              value = value.replaceAll(" ", "-");
              final db = FirebaseFirestore.instance;

              // Let's first check no kennel with this name exists
              try {
                final functions =
                    FirebaseFunctions.instanceFor(region: "europe-north1");
                final response = await functions
                    .httpsCallable("get_list_of_accounts")
                    .call();
                final responseData = response.data as Map<String, dynamic>;
                final accounts = List<String>.from(responseData["accounts"]);
                for (final account in accounts) {
                  if (account == value) {
                    BasicLogger().debug("Name taken");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(
                          context, "This kennel name is already taken"));
                    }
                    return;
                  }
                }
              } catch (e, s) {
                BasicLogger().error("Couldn't get existing accounts",
                    error: e, stackTrace: s);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(context, "Error: contact support"));
                }
                return;
              } finally {
                setState(() {
                  _isUpdating = false;
                });
              }
              final doc = db.doc("users/${widget.userName.uid}");
              try {
                await doc.update({"account": value});
                await db.doc("accounts/$value").set({"a": "a"});
              } catch (e, s) {
                BasicLogger()
                    .error("Couldn't create account", error: e, stackTrace: s);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(context, "Couldn't create kennel: $e"));
                }
                return;
              } finally {
                setState(() {
                  _isUpdating = false;
                });
              }
            },
            child: const Text("Create kennel"))
      ],
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
                      userLevel: UserLevel.musher,
                    ).toJson(),
                  );
                  return const Text("Creating user");
                } else if (userName.userType == UserType.reseller) {
                  return const ResellerHome();
                } else if (userName.account == null) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        children: [
                          const TextTitle("Create a kennel"),
                          const Text(
                              "You are not assigned to any kennel. Create a kennel and start using Mush on!"),
                          const Text(
                              "If you are an employee of a kennel already on Mush On, ask an administrator to send you an invite"),
                          CreateKennelTextAndButton(userName: userName),
                        ],
                      ),
                    ),
                  );
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
