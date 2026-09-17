import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';

class GoogleAuthRepository implements AuthRepository {
  GoogleAuthRepository({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;
  final GoogleSignIn _googleSignIn;
  bool _initialized = false;

  Future<void> _initialize() async {
    if (_initialized) return;
    await _googleSignIn.initialize();
    _initialized = true;
  }

  @override
  Future<GoogleSignInAccount?> restoreSession() async {
    await _initialize();
    final attempt = _googleSignIn.attemptLightweightAuthentication();
    return attempt == null ? null : await attempt;
  }

  @override
  Future<GoogleSignInAccount> signIn() async {
    await _initialize();
    if (!_googleSignIn.supportsAuthenticate()) {
      throw UnsupportedError('Interactive Google sign-in is not supported.');
    }
    return _googleSignIn.authenticate();
  }

  @override
  Future<void> signOut() async {
    await _initialize();
    await _googleSignIn.signOut();
  }
}
