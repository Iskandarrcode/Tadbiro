import 'package:bloc/bloc.dart';
import 'package:exam4/logic/blocs/auth_bloc/auth_events.dart';
import 'package:exam4/logic/blocs/auth_bloc/auth_state.dart';
import 'package:exam4/services/firebase_auth_http_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final AuthHttpServices firebaseAuthService;
  AuthBloc({
    required this.firebaseAuthService,
  }) : super(InitialAuthState()) {
    on<LoginUserEvents>(_loginUserEvent);
    on<RegisterUserEvents>(_registerUserEvent);
    on<LogoutUserEvents>(_logoutUserEvent);
    on<ResetUserPasswordEvents>(_resetUserPassswordEvent);
  }

  Future<void> _loginUserEvent(
      LoginUserEvents event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      await firebaseAuthService.loginUser(
          email: event.email, password: event.password);
      emit(LoadedAuthState());
    } on FirebaseException catch (e) {
      emit(ErrorAuthState(errorMessage: "Error: $e"));
      rethrow;
    }
  }

  Future<void> _registerUserEvent(
      RegisterUserEvents event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());

    try {
      await firebaseAuthService.registerUser(
        email: event.email,
        password: event.password,
      );

      //!add user sections

      emit(LoadedAuthState());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(errorMessage: "firebase error: $e"));
      rethrow;
    } catch (e) {
      emit(ErrorAuthState(errorMessage: "Error: $e"));
      rethrow;
    }
  }

  Future<void> _logoutUserEvent(
      LogoutUserEvents event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      await firebaseAuthService.logoutUser();
      emit(LoadedAuthState());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(errorMessage: "firebase error: $e"));
      rethrow;
    } catch (e) {
      emit(ErrorAuthState(errorMessage: "Error: $e"));
      rethrow;
    }
  }

  Future<void> _resetUserPassswordEvent(
      ResetUserPasswordEvents event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      await firebaseAuthService.resetPassword(email: event.email);
      emit(LoadedAuthState());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(errorMessage: 'firebase error: $e'));
      rethrow;
    } catch (e) {
      emit(ErrorAuthState(errorMessage: 'error: $e'));
      rethrow;
    }
  }
}
