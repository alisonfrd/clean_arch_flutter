import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:project/domain/usecases/usecases.dart';
import 'package:project/domain/helpers/helpers.dart';

import 'package:project/data/http/http.dart';
import 'package:project/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  AuthenticationParams params;
  String url;
  setUp(() {
    //arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    //sut == sistem  under test //
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });
  test('Garantir que será chamado o HttpClient com valores corretos', () async {
    //ação
    await sut.auth(params);

    //expect
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });
  test('Deve lançar um erro inexperado se o HttpClient retornar 400', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);
    //ação
    final future = sut.auth(params);

    //expect
    expect(future, throwsA(DomainError.unexpected));
  });
  test('Deve lançar um erro inexperado se o HttpClient retornar 404', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);
    //ação
    final future = sut.auth(params);

    //expect
    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'Deve lançar um erro InvalidCredencialError se o HttpClient retornar 401',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);
    //ação
    final future = sut.auth(params);

    //expect
    expect(future, throwsA(DomainError.invalidCredencial));
  });
}
