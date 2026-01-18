import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart'; // <--- NEW: Safe Platform Checking
import 'firebase_options.dart';
import 'core/theme/ghost_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/auth/auth_event.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // UNIVERSAL CHECK: 
  // Initialize Firebase ONLY if we are NOT on Linux Desktop.
  // (Web, Android, and iOS are fine).
  try {
    if (defaultTargetPlatform != TargetPlatform.linux) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print("Firebase Init Skipped: $e");
  }

  runApp(const GhostMeApp());
}

class GhostMeApp extends StatelessWidget {
  const GhostMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        )..add(AuthStarted()), // This is now safe to run everywhere
        child: MaterialApp(
          title: 'GhostMe',
          debugShowCheckedModeBanner: false,
          theme: GhostTheme.themeData,
          home: const LoginScreen(),
        ),
      ),
    );
  }
}