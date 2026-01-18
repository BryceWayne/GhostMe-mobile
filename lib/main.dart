import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'core/theme/ghost_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/auth/auth_event.dart';
// --- ADD THESE IMPORTS ---
import 'logic/blocs/chat/chat_bloc.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
      child: MultiBlocProvider(
        providers: [
          // This is the ONE true source of Auth state
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthStarted()),
          ),
          // This starts the WebSocket connection as soon as the app boots
          BlocProvider(
            create: (context) => ChatBloc()..add(ConnectToStream()),
          ),
        ],
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