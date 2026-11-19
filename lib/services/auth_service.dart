import 'package:shared_preferences/shared_preferences.dart';

const String validUsername = 'tata';
const String validPassword = '119';

class AuthService {
  static Future<bool> login(String username, String password) async {
    if (username != validUsername || password != validPassword) {
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginData', true);
    await prefs.setString('username', username);
    return true;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loginData') ?? false;
  }

  static Future<String> currentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginData', false);
    await prefs.remove('username');
  }
}
