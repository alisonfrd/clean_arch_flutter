import 'package:meta/meta.dart';

import '../entities/entites.dart';

abstract class Authentication {
  Future<AccountEntity> auth({
    @required String email,
    @required String password,
  });
}
