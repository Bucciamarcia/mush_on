import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';

const _googleClientId =
    "337862523976-bam0ptripclqt2fdvajqgg3bsm8qqaqh.apps.googleusercontent.com";

void configureMushOnAuthProviders() {
  FirebaseUIAuth.configureProviders([
    GoogleProvider(
      clientId: _googleClientId,
      redirectUri: kIsWeb ? Uri.base.toString() : null,
    ),
    EmailAuthProvider(),
  ]);
}
