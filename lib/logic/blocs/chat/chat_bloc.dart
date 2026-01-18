import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  
  // Cloud Run Endpoint
  final Uri _serverUrl = Uri.parse('wss://ghost-chat-574943856710.us-central1.run.app/ws');

  ChatBloc() : super(const ChatState()) {
    on<ConnectToStream>(_onConnect);
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<DisconnectFromStream>(_onDisconnect);
    on<DissolveMessage>(_onDissolveMessage);
  }

  Future<void> _onConnect(ConnectToStream event, Emitter<ChatState> emit) async {
    await _subscription?.cancel();
    _channel?.sink.close();
    emit(state.copyWith(status: "AUTHENTICATING...", isConnected: false));

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No authenticated user.");
      final token = await user.getIdToken();

      emit(state.copyWith(status: "LINKING..."));

      _channel = IOWebSocketChannel.connect(
        _serverUrl,
        protocols: ['json'], 
        headers: {'Authorization': 'Bearer $token'},
        pingInterval: const Duration(seconds: 30), 
      );

      await _channel!.ready;

      _subscription = _channel!.stream.listen(
        (data) => add(MessageReceived(data.toString())),
        onError: (e) {
            // Prevent spamming error logs, just disconnect
            add(DisconnectFromStream()); 
        },
        onDone: () => add(DisconnectFromStream()),
      );

      // Add a System message that also self-destructs
      final sysId = "sys_${DateTime.now().millisecondsSinceEpoch}";
      final sysMsg = GhostMessage(
          id: sysId, 
          text: "SYSTEM: CONNECTION SECURE.", 
          timestamp: DateTime.now()
      );
      
      emit(state.copyWith(
        isConnected: true, 
        status: "LINK ESTABLISHED",
        messages: [...state.messages, sysMsg]
      ));
      
      // System message fades after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (!isClosed) add(DissolveMessage(sysId));
      });

    } catch (e) {
      emit(state.copyWith(isConnected: false, status: "CONNECTION FAILED"));
      Future.delayed(const Duration(seconds: 5), () {
          if (!isClosed) add(ConnectToStream());
      });
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    if (state.isConnected && _channel != null) {
      try {
        final jsonMessage = jsonEncode({'text': event.message});
        _channel!.sink.add(jsonMessage);
        // No local update; we wait for the echo.
      } catch (e) {
        add(DisconnectFromStream());
      }
    }
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    String rawData = event.data.trim();
    if (rawData.isEmpty || rawData.contains('"type":"pong"')) return;
    
    // 1. PARSE HTMX
    String contentToDisplay = rawData;
    if (rawData.startsWith("<div") || rawData.startsWith("<p")) {
      try {
        final RegExp textFinder = RegExp(r'<p[^>]*>(.*?)<\/p>', dotAll: true);
        final match = textFinder.firstMatch(rawData);
        if (match != null && match.groupCount >= 1) {
          contentToDisplay = match.group(1)!.trim();
        } else {
          return; 
        }
      } catch (e) { return; }
    }
    if (contentToDisplay.isEmpty) return;

    // 2. FIX EMOJIS (Replace :ghost: with 👻)
    contentToDisplay = contentToDisplay.replaceAll(":ghost:", "👻");

    // 3. CREATE MESSAGE WITH UNIQUE ID
    final String msgId = DateTime.now().microsecondsSinceEpoch.toString();
    
    final newMessage = GhostMessage(
      id: msgId,
      text: "GHOST: $contentToDisplay",
      timestamp: DateTime.now(),
    );

    final newMessages = List<GhostMessage>.from(state.messages)..add(newMessage);
    emit(state.copyWith(messages: newMessages));

    // 4. SET TIMER: Message dissolves in 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (!isClosed) add(DissolveMessage(msgId));
    });
  }

  void _onDissolveMessage(DissolveMessage event, Emitter<ChatState> emit) {
    // Filter out the message with the matching ID
    final newMessages = state.messages.where((m) => m.id != event.id).toList();
    emit(state.copyWith(messages: newMessages));
  }

  void _onDisconnect(DisconnectFromStream event, Emitter<ChatState> emit) {
    if (state.status != "LINK SEVERED") {
      emit(state.copyWith(isConnected: false, status: "LINK SEVERED"));
      Future.delayed(const Duration(seconds: 3), () {
          if (!isClosed) add(ConnectToStream());
      });
    }
  }
  
  @override
  Future<void> close() {
    _subscription?.cancel();
    _channel?.sink.close();
    return super.close();
  }
}