import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/resellers/invite_resellers/repository.dart';
import 'package:mush_on/resellers/invite_resellers/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

class ResellerAcceptInvitation extends ConsumerWidget {
  final String? email;
  final String? securityCode;
  const ResellerAcceptInvitation(
      {super.key, required this.email, required this.securityCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    if (email == null || securityCode == null) {
      return const ErrorPage(message: "Email or security code missing");
    }
    final invitationAsync = ref.watch(resellerInvitationProvider(email!));
    return invitationAsync.when(
        data: (invitation) {
          if (invitation == null) {
            return const ErrorPage(
                message: "Invitation is not available in the database");
          }
          if (invitation.securityCode != securityCode) {
            return const ErrorPage(message: "The security code is incorrect");
          }
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
                        'Welcome to Mush On, please login to register your reseller account!')
                    : const Text(
                        'Welcome to Mush On, please login to register your reseller account!'),
              );
            },
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) async {
                final uid = state.user?.uid;
                final email = state.user?.email;
                if (uid == null || email == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(context, "Error: couldn't log in"));
                  return;
                }
                await InviteResellerRepository().onResellerSignin(
                    uid, email, invitation.account, invitation.discount);
                if (context.mounted) context.go("/reseller");
              }),
              AuthStateChangeAction<UserCreated>((context, state) async {
                final uid = state.credential.user?.uid;
                final email = state.credential.user?.email;
                if (uid == null || email == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(context, "Error: couldn't log in"));
                  return;
                }
                await InviteResellerRepository().onResellerSignin(
                    uid, email, invitation.account, invitation.discount);
                if (context.mounted) context.go("/reseller");
              }),
            ],
          );
        },
        error: (e, s) {
          logger.error("Couldn't get invitation", error: e, stackTrace: s);
          return const ErrorPage(
              message: "Couldn't retrieve the invitation from the database");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}

class ErrorPage extends StatelessWidget {
  final String message;
  const ErrorPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text(message)),
    );
  }
}
