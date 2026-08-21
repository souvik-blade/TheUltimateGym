import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app_root.dart';
import 'features/auth/state/profile_controller.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FitnessProApp());
}

class FitnessProApp extends StatelessWidget {
  const FitnessProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProfileController())],
      child: MaterialApp(
        title: 'Fitness Pro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const AppRoot(),
      ),
    );
  }
}
