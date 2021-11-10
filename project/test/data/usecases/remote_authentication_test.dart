import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:project/domain/usecases/usecases.dart';

import 'package:project/data/http/http.dart';

import 'package:project/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  setUp(() {
    //arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    //sut == sistem  under test //
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test('Garantir que será chamado o HttpClient com valores corretos', () async {
    //ação
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth(params);

    //expect
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });
}
