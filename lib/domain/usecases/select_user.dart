import 'package:shared_preferences/shared_preferences.dart';
import 'package:maimaid/domain/entities/user.dart';

class SelectUser {
  Future<void> call(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = user.toJsonString();
    prefs.setString('selected_user', jsonString);
  }
}
