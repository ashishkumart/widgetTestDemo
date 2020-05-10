// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgettestdemo/main_bloc.dart';
import 'package:widgettestdemo/main_event.dart';
import 'package:widgettestdemo/main_state.dart';
import 'package:widgettestdemo/model/create_account_data.dart';

void main() {
  group("Bloc Listener", () {
    testWidgets('throws if initialized with null bloc, listener, and child', (tester) async {
      try {
        await tester.pumpWidget(
          BlocListener<Bloc, dynamic>(
            bloc: null,
            listener: null,
            child: null,
          ),
        );
        fail('should throw AssertionError');
      } on dynamic catch (error) {
        expect(error, isAssertionError);
      }
    });

    testWidgets('throws if initialized with null listener and child', (tester) async {
      try {
        await tester.pumpWidget(
          BlocListener<MainBloc, MainState>(
            bloc: MainBloc(),
            listener: null,
            child: null,
          ),
        );
        fail('should throw AssertionError');
      } on dynamic catch (error) {
        expect(error, isAssertionError);
      }
    });

    testWidgets('renders child properly', (tester) async {
      final targetKey = Key('bloc_listener_container');
      await tester.pumpWidget(
        BlocListener(
          bloc: MainBloc(),
          listener: (context, state) {},
          child: Container(
            key: targetKey,
          ),
        ),
      );
      expect(find.byKey(targetKey), findsOneWidget);
    });

    testWidgets('calls listener on single state change', (tester) async {
      await tester.runAsync(() async {
        MainState latestState;
        var listenerCallCount = 0;
        final mainBloc = MainBloc();
        final expectedStates = [InitialState(), AccountCreatedState()];
        await tester.pumpWidget(
          BlocListener(
            bloc: mainBloc,
            listener: (context, state) {
              listenerCallCount++;
              latestState = state;
            },
            child: Container(),
          ),
        );
        CreateAccountData data = CreateAccountData();
        data.firstName = "first name";
        data.lastName = "last name";
        data.email = "email";
        data.password = "pass";

        mainBloc.add(CreateAccountPressedEvent(data));
        await tester.pumpAndSettle(Duration(milliseconds: 300));
        expectLater(mainBloc, emitsInOrder(expectedStates)).then((_) {
          expect(listenerCallCount, 1);
          expect(latestState, AccountCreatedState());
        });
      });
    });
  });
}
