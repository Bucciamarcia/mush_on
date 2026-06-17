import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/customer_facing/confirm_invitation/repository.dart';
import 'package:mush_on/login_screen/auth_providers.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/text_title.dart';

import 'riverpod.dart';

class ConfirmInvitation extends ConsumerWidget {
  final String? email;
  final String? securityCode;
  const ConfirmInvitation({
    super.key,
    required this.email,
    required this.securityCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    configureMushOnAuthProviders();
    if (email == null) {
      return const ErrorAcceptInvitation(errorText: "Email is null");
    }
    if (securityCode == null) {
      return const ErrorAcceptInvitation(errorText: "Security code is null");
    }
    final userInvitationAsync = ref.watch(
      userInvitationProvider(email: email!, securityCode: securityCode!),
    );
    return userInvitationAsync.when(
      data: (userInvitation) {
        Future<void> acceptWithSignedInUser() async {
          final user = FirebaseAuth.instance.currentUser;
          final signedInEmail = user?.email?.trim().toLowerCase();
          final invitedEmail = userInvitation.email.trim().toLowerCase();
          if (signedInEmail == null || signedInEmail != invitedEmail) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(
                  context,
                  "Sign in with the invited email address",
                ),
              );
            }
            return;
          }
          try {
            await ConfirmInvitationRepository().acceptInvitation(
              email: userInvitation.email,
              securityCode: securityCode!,
            );
            if (context.mounted) context.go("/");
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(
                  context,
                  "Cannot create a new user: contact support",
                ),
              );
            }
          }
        }

        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              children: [
                Image.asset("assets/images/logo.png", width: 150),
                const TextTitle("Join Mush On"),
                Text(
                  "You're invited to join account: ${userInvitation.account}",
                ),
                const Text("To join, log in:"),
                Expanded(
                  child: SignInScreen(
                    actions: [
                      AuthStateChangeAction<UserCreated>((context, state) {
                        acceptWithSignedInUser();
                      }),
                      AuthStateChangeAction<SignedIn>((context, state) {
                        acceptWithSignedInUser();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (e, s) {
        logger.error(
          "Couldn't get user invitation provider",
          error: e,
          stackTrace: s,
        );
        return ErrorAcceptInvitation(errorText: e.toString());
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
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
