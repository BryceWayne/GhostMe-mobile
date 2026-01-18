import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Fired when the app first launches to check if a user is already cached
class AuthStarted extends AuthEvent {}

// Fired when the user taps the "Summon Identity" button
class AuthLoginRequested extends AuthEvent {}

// Fired when the user taps "Banish Identity" (Logout)
class AuthLogoutRequested extends AuthEvent {}