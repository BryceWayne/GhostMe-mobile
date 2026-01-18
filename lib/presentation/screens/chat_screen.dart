import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/auth/auth_event.dart';
import '../../logic/blocs/chat/chat_bloc.dart';
import '../../core/theme/ghost_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Automatically scrolls the terminal to the bottom when a new message arrives
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TERMINAL_UPLINK"),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          // Connection Status Indicator
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Icon(
                Icons.circle,
                size: 12,
                color: state.isConnected ? GhostTheme.ectoGreen : GhostTheme.glitchRed,
              );
            },
          ),
          const SizedBox(width: 16),
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
          // --- THE VOID (Message Log) ---
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                // Scroll down whenever the "ghost" speaks or you send a message
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
              },
              builder: (context, state) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isGhost = message.startsWith("GHOST");
                    final isSystem = message.startsWith("SYSTEM");

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontFamily: 'ShareTechMono', // Ensure this matches your theme
                          fontSize: 16,
                          color: isSystem 
                              ? GhostTheme.hologramBlue.withOpacity(0.7)
                              : isGhost 
                                  ? GhostTheme.ectoGreen 
                                  : Colors.white.withOpacity(0.9),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // --- THE INPUT (Command Line) ---
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                top: BorderSide(color: GhostTheme.ectoGreen.withOpacity(0.2)),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  const Text(">> ", style: TextStyle(color: GhostTheme.ectoGreen, fontSize: 18)),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      style: const TextStyle(color: GhostTheme.ectoGreen, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: "TRANSMIT_TO_VOID...",
                        hintStyle: TextStyle(color: Colors.white24),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          context.read<ChatBloc>().add(SendMessage(value));
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: GhostTheme.ectoGreen),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        context.read<ChatBloc>().add(SendMessage(_controller.text));
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}