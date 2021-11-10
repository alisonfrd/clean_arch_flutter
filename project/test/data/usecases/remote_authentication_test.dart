import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({@required String url});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Garantir que será chamado o HttpClient com a URL correta', () async {
    //arrange
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    //sut == sistem  under test //
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    //ação
    await sut.auth();

    //expect
    verify(httpClient.request(url: url));
  });
}
