import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define providers

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
                      child: const Text("Go to accept invitation page")),
                  ElevatedButton(
                      onPressed: () => context.push(
                          "/reseller-signup?email=info@stefanominiconsulting.com&securityCode=908596e4-fb28-4716-a5fe-520804d9791c"),
                      child: const Text("Go to reseller signup page")),
                  ElevatedButton(
                      onPressed: () => context.go("/reseller"),
                      child: const Text("Go to reseller"))
                ],
              )
            : const SizedBox.shrink(),
        ElevatedButton(
          onPressed: () async {
            try {
              print('🧪 Testing direct auth emulator connection...');
              final userCred =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: 'test${DateTime.now().millisecondsSinceEpoch}@test.com',
                password: 'test123456',
              );
              print('✅ Auth emulator working! User: ${userCred.user?.email}');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emulator connection works!')),
              );
            } catch (e) {
              print('❌ Auth emulator test failed: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Emulator test failed: $e')),
              );
            }
          },
          child: const Text('Test Emulator Connection'),
        ),
        Expanded(
          child: SignInScreen(
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
