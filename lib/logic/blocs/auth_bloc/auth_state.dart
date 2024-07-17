sealed class AuthState {}

final class InitialAuthState extends AuthState {}

final class LoadingAuthState extends AuthState {}

final class LoadedAuthState extends AuthState {}

final class ErrorAuthState extends AuthState {
  String errorMessage;
  ErrorAuthState({required this.errorMessage});
}
