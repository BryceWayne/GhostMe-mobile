import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/chat/chat_bloc.dart';
import '../../logic/blocs/chat/chat_state.dart';
import '../../logic/blocs/chat/chat_event.dart';
import '../../core/theme/ghost_theme.dart';
import '../widgets/seance_header.dart'; 

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(_controller.text.trim()));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SeanceHeader(), // Menu button is now inside here
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index].text;
                      return _buildMessageItem(message);
                    },
                  );
                },
              ),
            ),
            _buildInputArea(context),
          ],
        ),
      ),
      // FLOATING ACTION BUTTON REMOVED
    );
  }

  Widget _buildMessageItem(String message) {
    Color textColor = GhostTheme.linkGreen;

    bool isGhost = message.startsWith("GHOST:");
    bool isSystem = message.startsWith("SYSTEM:");

    if (isSystem) textColor = GhostTheme.seanceLavender.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontFamily: isGhost ? 'CourierPrime' : 'ShareTechMono',
          fontSize: isGhost ? 16 : 14,
          shadows: isGhost
              ? [Shadow(color: GhostTheme.linkGreen.withOpacity(0.5), blurRadius: 8)]
              : [],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: GhostTheme.seanceLavender.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: GhostTheme.seanceLavender),
              cursorColor: GhostTheme.linkGreen,
              decoration: InputDecoration(
                hintText: "Incant your message...",
                hintStyle: TextStyle(color: GhostTheme.seanceLavender.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: GhostTheme.seanceLavender.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: GhostTheme.seanceLavender.withOpacity(0.3)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: GhostTheme.seanceLavender),
                ),
              ),
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send_outlined),
            color: GhostTheme.linkGreen,
            style: IconButton.styleFrom(
              backgroundColor: GhostTheme.linkGreen.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: GhostTheme.linkGreen, width: 1),
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}