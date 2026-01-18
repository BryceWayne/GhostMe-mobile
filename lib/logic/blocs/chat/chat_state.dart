import 'package:equatable/equatable.dart';

// The "Smart" Message Object
class GhostMessage extends Equatable {
  final String id;
  final String text;
  final DateTime timestamp;

  const GhostMessage({
    required this.id, 
    required this.text, 
    required this.timestamp
  });

  @override
  List<Object> get props => [id, text, timestamp];
}

class ChatState extends Equatable {
  final List<GhostMessage> messages; // Updated to use GhostMessage
  final bool isConnected;
  final String status;

  const ChatState({
    this.messages = const [], 
    this.isConnected = false,
    this.status = "DISCONNECTED"
  });

  ChatState copyWith({
    List<GhostMessage>? messages, 
    bool? isConnected, 
    String? status
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isConnected: isConnected ?? this.isConnected,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [messages, isConnected, status];
}