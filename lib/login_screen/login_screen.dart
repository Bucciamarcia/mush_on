import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define providers
    final providers = [
      GoogleProvider(
          clientId:
              "337862523976-bam0ptripclqt2fdvajqgg3bsm8qqaqh.apps.googleusercontent.com")
    ];

    void onSignedIn() {
      context.go('/');
    }

    return SignInScreen(
      providers: providers,
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset("assets/images/logo.png"),
          ),
        );
      },
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: action == AuthAction.signIn
              ? const Text('Welcome to Mush On, please sign in!')
              : const Text('Welcome to Mush On, please sign up!'),
        );
      },
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          onSignedIn();
        }),
        AuthStateChangeAction<UserCreated>((context, state) {
          onSignedIn();
        }),
      ],
    );
  }
}
