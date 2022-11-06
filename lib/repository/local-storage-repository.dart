import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository {
  void setTokenToStorage({required String token}) async {
    final preferences = await SharedPreferences.getInstance();

    // saving registeration token to local storage in web and shareprefernce in android and ios
    preferences.setString('x-auth-token', token);
  }

  Future<String?> getTokenFromLocalStorage() async {
    final preferences = await SharedPreferences.getInstance();

    String? token = preferences.getString('x-auth-token');

    return token;
  }

  void remoteTokenFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('x-auth-token');
  }
}
