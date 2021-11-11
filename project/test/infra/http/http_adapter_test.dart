import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);
  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'applicationjson/',
      'accept': 'applicationjson/',
    };
    await client.post(url, headers: headers, body: jsonEncode(body));
  }
}

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
  group('post', () {
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
  });
}