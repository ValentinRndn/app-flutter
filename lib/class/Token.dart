import 'package:shared_preferences/shared_preferences.dart';

class Token {
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt_token');
    return token;
  }
}
