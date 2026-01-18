import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/auth/auth_event.dart';
import '../../core/theme/ghost_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _logs = [
    "SYSTEM: CONNECTION ESTABLISHED...",
    "SYSTEM: LISTENING ON PORT 666...",
    "GHOST: I am listening.",
  ]; // Temporary fake data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TERMINAL_UPLINK"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: GhostTheme.glitchRed),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- THE CHAT LOG (The Void) ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final isSystem = _logs[index].startsWith("SYSTEM");
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    _logs[index],
                    style: isSystem
                        ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: GhostTheme.hologramBlue.withOpacity(0.7),
                              fontSize: 12,
                            )
                        : Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              },
            ),
          ),

          // --- THE INPUT FIELD (The Seance) ---
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: GhostTheme.ectoGreen.withOpacity(0.3)),
              ),
              color: Colors.black,
            ),
            child: Row(
              children: [
                const Text(">> ", style: TextStyle(color: GhostTheme.ectoGreen)),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: "TRANSMIT MESSAGE...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _logs.add("YOU: $value");
                        _controller.clear();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: GhostTheme.ectoGreen),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _logs.add("YOU: ${_controller.text}");
                        _controller.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}