abstract class LoginPresenter {
  Stream get emailErrorStream;
  Stream get passwordErrorStream;
  Stream get isValidErrorStream;
  Stream get isLoadingStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
}
