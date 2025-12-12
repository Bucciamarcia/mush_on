import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
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
            "337862523976-bam0ptripclqt2fdvajqgg3bsm8qqaqh.apps.googleusercontent.com",
        redirectUri: kIsWeb ? Uri.base.toString() : null,
      )
    ];

    void onSignedIn() {
      context.go('/');
    }

    return Column(
      children: [
        kDebugMode
            ? Column(
                children: [
                  ElevatedButton(
                      onPressed: () => context.go(
                          "/booking?kennel=test-stefano&tourId=76c1e154-baf5-460f-9072-a8638042ee61"),
                      child: const Text("Go to test page")),
                  ElevatedButton(
                    child: const Text("Go to confirmation page"),
                    onPressed: () => context.go(
                        "/booking_success?bookingId=7726c0de-fd6e-4efd-a3fb-2466ff7c3b39&account=test-stefano"),
                  ),
                  ElevatedButton(
                      onPressed: () => context.push(
                          "/accept_invitation?email=info@stefanominiconsulting.com&securityCode=6"),
                      child: const Text("Go to accept invitation page"))
                ],
              )
            : const SizedBox.shrink(),
        Expanded(
          child: SignInScreen(
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
          ),
        ),
      ],
    );
  }
}
