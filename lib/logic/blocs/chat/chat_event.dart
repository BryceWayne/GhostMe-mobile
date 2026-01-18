import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class ConnectToStream extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;
  const SendMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class MessageReceived extends ChatEvent {
  final String data;
  const MessageReceived(this.data);
  @override
  List<Object?> get props => [data];
}

class DisconnectFromStream extends ChatEvent {}

// NEW: Removes a specific message by ID
class DissolveMessage extends ChatEvent {
  final String id;
  const DissolveMessage(this.id);
  @override
  List<Object?> get props => [id];
}