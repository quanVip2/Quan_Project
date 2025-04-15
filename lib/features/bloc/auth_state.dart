abstract class AuthState {}
// auth_state.dart
class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;

  // Constructor yêu cầu token
  AuthAuthenticated({required this.token});
}

class AuthUnauthenticated extends AuthState {}
