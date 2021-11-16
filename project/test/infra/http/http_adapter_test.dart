import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:project/data/http/http.dart';

import 'package:project/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;
  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test('deve lancar um ServerError se o metodo for invalido', () async {
      final future = sut.request(url: url, method: 'invalid_method');

      expect(future, throwsA(HttpError.serverError));
    });
  });
  group('post', () {
    PostExpectation mockRequest() => when(
        client.post(url, body: anyNamed('body'), headers: anyNamed('headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });
    test('deve encaminhar um Post com os valores corretos', () async {
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(
        client.post(url,
            headers: {
              'content-type': 'applicationjson/',
              'accept': 'applicationjson/'
            },
            body: '{"any_key":"any_value"}'),
      );
    });
    test('deve encaminhar um Post sem o Body', () async {
      await sut.request(url: url, method: 'post');

      verify(
        client.post(
          any,
          headers: anyNamed('headers'),
        ),
      );
    });

    test('deve retornar dados se o statusCode for 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('deve retornar nulo se o statusCode for 200 e não conter dados',
        () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
    test('deve retornar nulo se o statusCode for 204', () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('deve retornar BadResquest se o statusCode for 400', () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('deve retornar BadResquest se o statusCode for 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('deve retornar UnauthoziedError se o statusCode for 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('deve retornar ForbidenError se o statusCode for 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('deve retornar NotFoundError se o statusCode for 404', () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('deve retornar ServerError se o statusCode for 500', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('deve retornar ServerError se throw', () async {
      mockError();
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
