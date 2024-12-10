import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_application_4/models/recipe_model.dart';
import 'package:flutter_application_4/models/apiresponse_model.dart';
import 'package:flutter_application_4/service/session_service.dart';

const String baseUrl = "https://recipe.incube.id/api";

class RecipeService {
  final SessionService _sessionService = SessionService();

  Future<List<RecipeModel>> getAllRecipe() async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/recipes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final data = responseBody['data']?['data'];
      if (data != null) {
        return List<RecipeModel>.from(
            data.map((json) => RecipeModel.fromJson(json)));
      } else {
        throw Exception("Data tidak ditemukan dalam response");
      }
    } else {
      throw Exception("Gagal mengambil data: ${response.body}");
    }
  }

  Future<RecipeModel> getRecipeDetail(int recipeId) async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/recipes/$recipeId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return RecipeModel.fromJson(responseBody['data']);
    } else {
      throw Exception("Gagal mengambil data detail resep: ${response.body}");
    }
  }

  Future<RecipePagination> getRecipePagination({int page = 1}) async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/recipes?page=$page'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['data'];
      if (responseData != null) {
        return RecipePagination.fromJson(responseData);
      } else {
        throw Exception("Data tidak ditemukan dalam response");
      }
    } else {
      throw Exception("Gagal mengambil daftar resep");
    }
  }

  Future<ApiresponseModel> createRecipe({
    required String title,
    required String cookingMethod,
    required String ingredients,
    required String description,
    required File photo,
  }) async {
    final token = await _sessionService.getToken();
    final uri = Uri.parse('$baseUrl/recipes');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = title
      ..fields['cooking_method'] = cookingMethod
      ..fields['ingredients'] = ingredients
      ..fields['description'] = description
      ..files.add(await http.MultipartFile.fromPath('photo', photo.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return ApiresponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Gagal membuat resep: ${response.body}");
    }
  }

  Future<ApiresponseModel> updateRecipe({
    required int id,
    required String title,
    required String cookingMethod,
    required String ingredients,
    required String description,
    File? photo,
  }) async {
    final token = await _sessionService.getToken();
    final uri = Uri.parse('$baseUrl/recipes/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = title
      ..fields['cooking_method'] = cookingMethod
      ..fields['ingredients'] = ingredients
      ..fields['description'] = description;

    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ApiresponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Gagal memperbarui resep: ${response.body}");
    }
  }

  Future<ApiresponseModel> deleteRecipe(int id) async {
    final token = await _sessionService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/recipes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ApiresponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Gagal menghapus resep: ${response.body}");
    }
  }
}
