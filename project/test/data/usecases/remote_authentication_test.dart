import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:project/domain/usecases/usecases.dart';
import 'package:project/domain/helpers/helpers.dart';

import 'package:project/data/http/http.dart';
import 'package:project/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  //sut == sistem  under test //

  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  AuthenticationParams params;
  String url;

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    //arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });
  test('Garantir que será chamado o HttpClient com valores corretos', () async {
    await sut.auth(params);

    //expect
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });
  test('Deve lançar um erro inexperado se o HttpClient retornar 400', () async {
    mockHttpError(HttpError.badRequest);
    //ação
    final future = sut.auth(params);

    //expect
    expect(future, throwsA(DomainError.unexpected));
  });
  test('Deve lançar um erro inexperado se o HttpClient retornar 404', () async {
    mockHttpError(HttpError.notFound);
    //ação
    final future = sut.auth(params);

    //expect
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve lançar um erro inexperado se o HttpClient retornar 500', () async {
    mockHttpError(HttpError.serverError);
    //ação
    final future = sut.auth(params);

    //expect
    expect(future, throwsA(DomainError.unexpected));
  });
  test(
      'Deve lançar um erro InvalidCredencialError se o HttpClient retornar 401',
      () async {
    mockHttpError(HttpError.unauthorized);
    //ação
    final future = sut.auth(params);

    //expect
    expect(future, throwsA(DomainError.invalidCredencial));
  });

  test('Deve retornar um Account se o HttpClient retornar 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);
    //ação
    final account = await sut.auth(params);

    //expect
    expect(account.token, validData['accessToken']);
  });

  test(
      'Deve retornar um UnexpectedError se o HttpClient retornar 200 com campos inválidos',
      () async {
    mockHttpData({
      'invalid_token': 'invalid_token',
    });
    //ação
    final future = sut.auth(params);

    //expect
    expect(future, throwsA(DomainError.unexpected));
  });
}
