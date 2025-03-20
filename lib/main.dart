import 'package:flutter/material.dart';
import 'package:mush_on/routes.dart';
import 'package:mush_on/services/auth.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:provider/provider.dart';
import 'home_page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_screen/login_screen.dart';
import 'provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DogProvider(),
        ),
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
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else if (snapshot.hasData) {
          FirestoreService().userLoginActions();
          return FutureBuilder<String?>(
              future: FirestoreService().getUserAccount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error.toString()}"),
                  );
                } else {
                  // Data loaded - could be null or a value
                  final accountData = snapshot.data;

                  if (accountData == null) {
                    return Scaffold(
                      body: Container(
                        padding: EdgeInsets.all(10),
                        child: SafeArea(
                          child: Text(
                              "Access not authorized. This is normal for new accounts. The admin will authorize your account as needed."),
                        ),
                      ),
                    );
                  } else {
                    return HomePageScreen();
                  }
                }
              });
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
