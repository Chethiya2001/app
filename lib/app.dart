import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/auth_gate.dart';

class HotelsApp extends StatelessWidget {
  const HotelsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Hotel Explorer',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const AuthGate(),
  );
}
