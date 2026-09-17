import 'package:google_sign_in/google_sign_in.dart';

abstract interface class AuthRepository {
  Future<GoogleSignInAccount?> restoreSession();
  Future<GoogleSignInAccount> signIn();
  Future<void> signOut();
}
