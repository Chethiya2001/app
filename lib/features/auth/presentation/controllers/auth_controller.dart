import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/repositories/google_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => GoogleAuthRepository(),
);
final authControllerProvider =
    AsyncNotifierProvider<AuthController, GoogleSignInAccount?>(
      AuthController.new,
    );

class AuthController extends AsyncNotifier<GoogleSignInAccount?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);
  @override
  Future<GoogleSignInAccount?> build() => _repository.restoreSession();

  Future<void> signIn() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signIn);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.signOut();
      return null;
    });
  }
}
