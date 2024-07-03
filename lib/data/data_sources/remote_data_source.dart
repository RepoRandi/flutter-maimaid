import 'package:maimaid/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemoteDataSource {
  final http.Client client;

  RemoteDataSource(this.client);

  Future<List<UserModel>> getUsers(int page) async {
    final response = await client.get(
      Uri.parse('https://reqres.in/api/users?page=$page&per_page=10'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<UserModel> getUserDetail(int id) async {
    final response = await client.get(
      Uri.parse('https://reqres.in/api/users/$id'),
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      return UserModel.fromJson(decodedJson);
    } else {
      throw Exception('Failed to load user detail');
    }
  }

  Future<void> createUser(Map<String, dynamic> user) async {
    final response = await client.post(
      Uri.parse('https://reqres.in/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create user');
    }
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final response = await client.put(
      Uri.parse('https://reqres.in/api/users/${user['id']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await client.delete(
      Uri.parse('https://reqres.in/api/users/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
