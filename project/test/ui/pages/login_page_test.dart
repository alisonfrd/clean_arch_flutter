import 'dart:async';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:project/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<String> mainErrorController;
  StreamController<bool> isFormValidontroller;
  StreamController<bool> isLoadController;

  void initStreams() {
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    mainErrorController = StreamController<String>();
    isFormValidontroller = StreamController<bool>();
    isLoadController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.isValidErrorStream)
        .thenAnswer((_) => isFormValidontroller.stream);
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidontroller.close();
    isLoadController.close();
    mainErrorController.close();
  }

  Future<void> loadTester(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    initStreams();
    mockStreams();
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('deve carregar com o estado inicial correto',
      (WidgetTester tester) async {
    await loadTester(tester);
    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason:
            'Quando um textField tiver somente um filho significa que ele não tem erro, caso tenha mais de um significa que ele tem um erro');

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('deve chamar validador com valores corretos',
      (WidgetTester tester) async {
    await loadTester(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });

  testWidgets('deve apresentar um erro se o email for inválido',
      (WidgetTester tester) async {
    await loadTester(tester);

    emailErrorController.add('any error');
    //renderiza os componentes
    await tester.pump();
    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('não deve apresentar um erro se o email for válido',
      (WidgetTester tester) async {
    await loadTester(tester);

    emailErrorController.add(null);
    //renderiza os componentes
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });
  testWidgets('não deve apresentar um erro se o email for válido',
      (WidgetTester tester) async {
    await loadTester(tester);

    emailErrorController.add('');
    //renderiza os componentes
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('deve apresentar um erro se o senha for inválida',
      (WidgetTester tester) async {
    await loadTester(tester);

    passwordErrorController.add('any error');
    //renderiza os componentes
    await tester.pump();
    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('não deve apresentar um erro se o senha for válido',
      (WidgetTester tester) async {
    await loadTester(tester);

    passwordErrorController.add(null);
    //renderiza os componentes
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });
  testWidgets('não deve apresentar um erro se o senha for válido',
      (WidgetTester tester) async {
    await loadTester(tester);

    passwordErrorController.add('');
    //renderiza os componentes
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('deve habilitar o botao se o formulario for valido',
      (WidgetTester tester) async {
    await loadTester(tester);

    isFormValidontroller.add(true);
    //renderiza os componentes
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('deve desabilitar o botao se o formulario for invalido',
      (WidgetTester tester) async {
    await loadTester(tester);

    isFormValidontroller.add(false);
    //renderiza os componentes
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
  });
  testWidgets('deve apresentar um loading', (WidgetTester tester) async {
    await loadTester(tester);

    isLoadController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('deve ocultar o loading', (WidgetTester tester) async {
    await loadTester(tester);

    isLoadController.add(true);
    await tester.pump();
    isLoadController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
  testWidgets('deve apresentar uma mensagem de erro se a autenticação falhar',
      (WidgetTester tester) async {
    await loadTester(tester);

    mainErrorController.add('main error');
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets('deve fecha as streams no dispose', (WidgetTester tester) async {
    await loadTester(tester);

    addTearDown(() {
      verify(presenter.dispose()).called(1);
    });
  });
}
