sealed class AuthEvents {}

final class LoginUserEvents extends AuthEvents {
  String email;
  String password;

  LoginUserEvents({required this.email, required this.password});
}

final class RegisterUserEvents extends AuthEvents {
  String email;
  String password;

  RegisterUserEvents({required this.email, required this.password});
}

final class LogoutUserEvents extends AuthEvents {}

final class ResetUserPasswordEvents extends AuthEvents {
  String email;

  ResetUserPasswordEvents({required this.email});
}
