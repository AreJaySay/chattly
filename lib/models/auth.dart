class AuthModel{
  String firebaseToken;
  Map? loggedUser;

  AuthModel({
    this.firebaseToken = "",
    this.loggedUser
  });
}

AuthModel authModel = new AuthModel();