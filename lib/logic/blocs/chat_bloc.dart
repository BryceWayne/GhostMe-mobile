import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:equatable/equatable.dart';

// --- EVENTS ---
abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectToStream extends ChatEvent {}
class SendMessage extends ChatEvent {
  final String message;
  SendMessage(this.message);
}

// --- STATE ---
class ChatState extends Equatable {
  final List<String> messages;
  final bool isConnected;

  const ChatState({this.messages = const [], this.isConnected = false});

  ChatState copyWith({List<String>? messages, bool? isConnected}) {
    return ChatState(
      messages: messages ?? this.messages,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [messages, isConnected];
}

// --- BLOC ---
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  WebSocketChannel? _channel;

  ChatBloc() : super(const ChatState()) {
    on<ConnectToStream>((event, emit) async {
      // REPLACE with your actual server URL later
      _channel = WebSocketChannel.connect(
        Uri.parse('wss://echo.websocket.events'), 
      );

      emit(state.copyWith(isConnected: true));

      // Listen to the "Ghost" responses
      await emit.forEach(
        _channel!.stream,
        onData: (data) {
          final newMessages = List<String>.from(state.messages)..add("GHOST: $data");
          return state.copyWith(messages: newMessages);
        },
      );
    });

    on<SendMessage>((event, emit) {
      if (_channel != null) {
        _channel!.sink.add(event.message);
        final newMessages = List<String>.from(state.messages)..add("YOU: ${event.message}");
        emit(state.copyWith(messages: newMessages));
      }
    });
  }

  @override
  Future<void> close() {
    _channel?.sink.close();
    return super.close();
  }
}