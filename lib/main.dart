import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'app/app_root.dart';
import 'features/auth/state/profile_controller.dart';
import 'theme/app_theme.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
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
