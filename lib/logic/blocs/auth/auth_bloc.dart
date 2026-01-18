import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    
    // Handle App Start
    on<AuthStarted>(_onAuthStarted);
    
    // Handle Login Request
    on<AuthLoginRequested>(_onAuthLoginRequested);
    
    // Handle Logout Request
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    // Check if user is already signed in from a previous session
    final user = _authRepository.currentUser;
    if (user != null) {
      try {
        // We need a fresh token for the backend connection
        final token = await user.getIdToken();
        if (token != null) {
          emit(AuthAuthenticated(user: user, idToken: token));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (_) {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await _authRepository.signInWithGoogle();
      final user = _authRepository.currentUser;

      if (token != null && user != null) {
        emit(AuthAuthenticated(user: user, idToken: token));
      } else {
        emit(const AuthFailure("Summoning aborted by user."));
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(AuthUnauthenticated());
  }
}