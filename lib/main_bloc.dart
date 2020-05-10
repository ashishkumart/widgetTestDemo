import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  @override
  MainState get initialState => InitialState();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is CreateAccountPressedEvent) {
      await Future.delayed(Duration(milliseconds: 200));

      yield AccountCreatedState();
    }
  }
}
