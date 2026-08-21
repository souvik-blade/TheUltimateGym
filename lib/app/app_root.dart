import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/state/profile_controller.dart';
import '../features/auth/welcome_screen.dart';
import 'app_shell.dart';
import 'splash_screen.dart';

/// The whole app's routing decision lives here: no profile -> Welcome
/// (register); profile exists but signed out -> Login; signed in -> the
/// main shell. A plain switch on [ProfileController] state instead of a
/// routing package — there's no deep-linking or web target to justify one.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileController>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    if (!controller.isInitialized) {
      return const SplashScreen();
    }
    if (!controller.hasAccount) {
      return const WelcomeScreen();
    }
    if (!controller.isSignedIn) {
      return const LoginScreen();
    }
    return const AppShell();
  }
}
