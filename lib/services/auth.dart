import 'package:firebase_auth/firebase_auth.dart';
import 'package:mush_on/services/error_handling.dart';

class AuthService {
  BasicLogger logger = BasicLogger();
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e, s) {
      logger.fatal("FirebaseAuthException", error: e, stackTrace: s);
      rethrow;
    }
  }
}
