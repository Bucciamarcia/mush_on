import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResellerLogin extends StatelessWidget {
  const ResellerLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
        providers: FirebaseUIAuth.providersFor(FirebaseAuth.instance.app),
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
                ? const Text(
                    'Welcome to Mush On, please login to your reseller account')
                : const Text(
                    'Welcome to Mush On, if you\'re trying to sign in: you should use an invite link'),
          );
        },
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) async {
            context.go("reseller");
          }),
          AuthStateChangeAction<UserCreated>((context, state) async {
            context.go("reseller");
          }),
        ]);
  }
}
