import 'package:exam4/logic/blocs/favorite_bloc/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FavoriteEvent { toggle }


class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteState(false)) {
    on<FavoriteEvent>((event, emit) {
      if (event == FavoriteEvent.toggle) {
        emit(FavoriteState(!state.isFavorite));
      }
    });
  }
}
