import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/auth/auth_event.dart';
import '../../logic/blocs/auth/auth_state.dart';
import '../../core/theme/ghost_theme.dart';
// The "Import Fix": This line tells Flutter where to find the ChatScreen class
import 'chat_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("ERROR: ${state.message}"),
              backgroundColor: GhostTheme.glitchRed,
            ),
          );
        }
        
        if (state is AuthAuthenticated) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("IDENTITY CONFIRMED. ENTERING THE VOID..."),
              backgroundColor: GhostTheme.ectoGreen,
              duration: Duration(seconds: 1),
            ),
          );

          // Pushes the ChatScreen onto the view and removes the LoginScreen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: GhostTheme.ectoGreen),
            ),
          );
        }

        return Scaffold(
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Text(
                  "GHOST_ME",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "ECHOES IN THE MACHINE",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 1),
                Icon(
                  Icons.fingerprint, 
                  size: 80, 
                  color: GhostTheme.ectoGreen.withOpacity(0.5)
                ),
                const Spacer(flex: 1),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLoginRequested());
                    },
                    child: const Text("SUMMON IDENTITY"),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "v1.0.0 // PROTOCOL: WEBSOCKET",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        );
      },
    );
  }
}