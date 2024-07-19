// import 'package:bloc/bloc.dart';
// import 'theme_event.dart';
// import 'theme_state.dart';

// class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
//   ThemeBloc() : super(LightThemeState()) {
//     on<ToggleThemeEvent>((event, emit) {
//       if (state is LightThemeState) {
//         emit(DarkThemeState());
//       } else {
//         emit(LightThemeState());
//       }
//     });
//   }

//   @override
//   Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
//     if (event is ToggleThemeEvent) {
//       if (state is LightThemeState) {
//         yield DarkThemeState();
//       } else {
//         yield LightThemeState();
//       }
//     }
//   }
// }


import 'package:bloc/bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(LightThemeState()) {
    // on metodini ishlatib, eventlarni ro'yxatdan o'tkazish
    on<ToggleThemeEvent>((event, emit) {
      if (state is LightThemeState) {
        emit(DarkThemeState());
      } else {
        emit(LightThemeState());
      }
    });
  }

}
