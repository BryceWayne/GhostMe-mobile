import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

// Ensure these paths match your actual folder structure
import 'core/theme/ghost_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/auth/auth_event.dart';
import 'logic/blocs/chat/chat_bloc.dart';
import 'logic/blocs/chat/chat_event.dart'; // Added for ConnectToStream
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Keeping your Linux-safety check for Firebase
    if (defaultTargetPlatform != TargetPlatform.linux) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint("Firebase Init Skipped or Failed: $e");
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
          // Auth State Management
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthStarted()),
          ),
          // WebSocket Management - initializing the séance link
          BlocProvider(
            create: (context) => ChatBloc()..add(ConnectToStream()),
          ),
        ],
        child: MaterialApp(
          title: 'GhostMe',
          debugShowCheckedModeBanner: false,
          
          // Applying the Occult-Tech theme we defined in ghost_theme.dart
          theme: GhostTheme.themeData,
          
          // Using a builder is a best practice to ensure Theme.of(context) 
          // works correctly in lower-level widgets if needed.
          home: const LoginScreen(),
          
          // Optional: Add a transition builder here later if you want 
          // "glitch" transitions between screens.
        ),
      ),
    );
  }
}