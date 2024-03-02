import 'package:dio/dio.dart';

import '../../features/auth/models/login.dart';
import '../../features/products/models/product.dart';
import '../../features/profile/models/profile.dart';
import '../../features/todos/models/todo.dart';

class ApiClient {
  final Dio httpClient;

  ApiClient() : httpClient = Dio()..options.baseUrl = 'https://dummyjson.com';
  ApiClient._withOptions(BaseOptions options) : httpClient = Dio(options);

  ApiClient copyWithToken(String token) {
    return ApiClient._withOptions(
        httpClient.options..headers['Authorization'] = 'Bearer $token');
  }

  Future<(Profile, String)> login(Login data) async {
    final response = await httpClient.post(
      '/auth/login',
      data: data.toJson(),
    );

    final profile = Profile.fromJson(response.data as Map<String, Object?>);
    final token = response.data['token'] as String;

    return (profile, token);
  }

  Future<List<Product>> fetchProducts() async {
    final response = await httpClient.get('/products');

    return (response.data['products'] as List)
        .cast<Map<String, Object?>>()
        .map(Product.fromJson)
        .toList();
  }

  Future<Product> fetchProduct(int id) async {
    final response = await httpClient.get('/products/$id');

    return Product.fromJson(response.data as Map<String, Object?>);
  }

  Future<List<Todo>> fetchTodos() async {
    final response = await httpClient.get('/todos');

    return (response.data['todos'] as List)
        .cast<Map<String, Object?>>()
        .map(Todo.fromJson)
        .toList();
  }

  Future<Todo> fetchTodo(int id) async {
    final response = await httpClient.get('/todos/$id');

    return Todo.fromJson(response.data as Map<String, Object?>);
  }

  Future<Todo> addTodo(Todo todo) async {
    final response = await httpClient.post(
      '/todos/add',
      data: todo.toJson()..remove('id'),
    );

    return Todo.fromJson(response.data as Map<String, Object?>);
  }

  Future<Todo> updateTodo(int id, Todo todo) async {
    final response = await httpClient.put(
      '/todos/$id',
      data: todo.toJson()..remove('id'),
    );

    return Todo.fromJson(response.data as Map<String, Object?>);
  }

  Future<Todo> deleteTodo(int id) async {
    final response = await httpClient.delete('/todos/$id');

    return Todo.fromJson(response.data as Map<String, Object?>);
  }
}
