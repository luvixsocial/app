class Auth {
  static Future<bool> login(String email, String password) async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 1));
    return email == '' && password == '' ? false : true;
  }

  static Future<bool> register(String email, String password) async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 1));
    return email == '' && password == '' ? false : true;
  }

  static Future<bool> logout() async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  static Future<bool> resetPassword(String email) async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 1));
    return email == '' ? false : true;
  }

  static Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 1));
    return oldPassword == '' && newPassword == '' ? false : true;
  }

  static Future<bool> updateLogin(String email, String pass) async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 1));
    return email == '' && pass == '' ? false : true;
  }
}
