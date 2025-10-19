import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/customer_facing/confirm_invitation/repository.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/username.dart';
import 'package:mush_on/shared/text_title.dart';

import 'riverpod.dart';

class ConfirmInvitation extends ConsumerWidget {
  final String? email;
  final String? securityCode;
  const ConfirmInvitation(
      {super.key, required this.email, required this.securityCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    if (email == null) {
      return const ErrorAcceptInvitation(errorText: "Email is null");
    }
    if (securityCode == null) {
      return const ErrorAcceptInvitation(errorText: "Security code is null");
    }
    final userInvitationAsync =
        ref.watch(userInvitationProvider(email: email!));
    return userInvitationAsync.when(
        data: (userInvitation) {
          if (userInvitation.securityCode != securityCode) {
            return const ErrorAcceptInvitation(
                errorText: "The security code is wrong");
          }
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                children: [
                  Image.asset("assets/images/logo.png", width: 150),
                  const TextTitle("Join Mush On"),
                  Text(
                      "You're invited to join account: ${userInvitation.account}"),
                  const Text("To join, log in:"),
                  ElevatedButton(
                      onPressed: () async {
                        late final UserCredential result;
                        if (kIsWeb) {
                          final provider = GoogleAuthProvider();
                          result = await FirebaseAuth.instance
                              .signInWithPopup(provider);
                        } else {
                          final provider = GoogleAuthProvider();
                          result = await FirebaseAuth.instance
                              .signInWithProvider(provider);
                        }
                        final user = result.user;
                        if (user == null) return;
                        final email = user.email;
                        if (email == null) return;
                        final userName = UserName(
                            uid: user.uid,
                            email: email,
                            account: userInvitation.account,
                            userLevel: userInvitation.userLevel);
                        try {
                          await ConfirmInvitationRepository()
                              .createAccount(userName);
                          if (context.mounted) context.go("/");
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context,
                                    "Cannot create a new user: contact support"));
                          }
                        }
                      },
                      child: const Text("Log in")),
                ],
              ),
            ),
          );
        },
        error: (e, s) {
          logger.error("Couldn't get user invitation provider",
              error: e, stackTrace: s);
          return ErrorAcceptInvitation(errorText: e.toString());
        },
        loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ));
  }
}

class ErrorAcceptInvitation extends StatelessWidget {
  final String errorText;
  const ErrorAcceptInvitation({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error!")),
      body: Center(child: Text(errorText)),
    );
  }
}
