class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  String? name;
  String? email;
  String? password;
}

final userSession = UserSession();
