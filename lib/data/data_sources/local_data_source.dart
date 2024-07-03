import 'package:maimaid/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalDataSource {
  Future<void> selectUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedUsers = await getSelectedUsers();

    selectedUsers.add(user);
    final jsonString =
        jsonEncode(selectedUsers.map((u) => u.toJson()).toList());

    await prefs.setString('selected_users', jsonString);
  }

  Future<void> deleteUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedUsers = await getSelectedUsers();

    selectedUsers.removeWhere((u) => u.id == user.id);
    final jsonString =
        jsonEncode(selectedUsers.map((u) => u.toJson()).toList());

    await prefs.setString('selected_users', jsonString);
  }

  Future<List<User>> getSelectedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('selected_users');

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => User.fromJson(json)).toList();
    }

    return [];
  }
}
