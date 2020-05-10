import 'package:equatable/equatable.dart';

import 'model/create_account_data.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class CreateAccountPressedEvent extends MainEvent {
  final CreateAccountData data;

  CreateAccountPressedEvent(this.data);

  @override
  List<Object> get props => [data];
}
