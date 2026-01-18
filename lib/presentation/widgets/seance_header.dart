import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/chat/chat_bloc.dart';
import '../../logic/blocs/chat/chat_state.dart';
import '../../logic/blocs/auth/auth_bloc.dart'; // Import AuthBloc
import '../../logic/blocs/auth/auth_event.dart'; // Import AuthEvent
import '../../core/theme/ghost_theme.dart';

class SeanceHeader extends StatelessWidget {
  const SeanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final Color statusColor = state.isConnected 
            ? GhostTheme.linkGreen 
            : GhostTheme.glitchRed;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 15, 10, 15), // Adjusted padding
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(color: statusColor.withOpacity(0.2), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- LEFT: TITLE & STATUS ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SÉANCE",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      shadows: [
                        Shadow(color: statusColor.withOpacity(0.5), blurRadius: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: statusColor, blurRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.status,
                        style: TextStyle(
                          color: statusColor,
                          fontFamily: 'ShareTechMono',
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // --- RIGHT: TECH SPECS + MENU BUTTON ---
              Row(
                children: [
                  // Tech Specs (Hidden on very small screens if needed)
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("ENC: AES-256", 
                        style: TextStyle(color: Colors.white24, fontSize: 8, fontFamily: 'ShareTechMono')),
                      Text("FREQ: 66.6 MHZ", 
                        style: TextStyle(color: Colors.white24, fontSize: 8, fontFamily: 'ShareTechMono')),
                    ],
                  ),
                  const SizedBox(width: 12),
                  
                  // THE MOVED MENU BUTTON
                  IconButton(
                    icon: const Icon(Icons.menu),
                    color: GhostTheme.linkGreen,
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}