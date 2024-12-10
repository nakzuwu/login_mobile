import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_application_4/models/recipe_model.dart';
import 'package:flutter_application_4/service/session_service.dart';

const String baseUrl = "https://recipe.incube.id/api";

class RecipeService {
  SessionService _sessionService = SessionService();
  Future<List<RecipeModel>> getAllRecipe() async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      print("Tidak ada token");
    }
    final response = await http.get(Uri.parse('$baseUrl/recipes'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data']['data'];
      return data.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future<RecipeModel> getRecipeDetail(int id) async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/recipes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return RecipeModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception("Resep tidak ditemukan");
    } else {
      throw Exception("Gagal mengambil data detail resep");
    }
  }
}
