import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../hotels/presentation/screens/hotel_list_screen.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    return auth.when(
      data: (account) => account == null
          ? const LoginScreen()
          : HotelListScreen(account: account),
      error: (_, _) => const LoginScreen(),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
