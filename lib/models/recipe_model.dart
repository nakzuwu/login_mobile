import 'dart:convert';

RecipeModel recipeModelFromJson(String str) =>
    RecipeModel.fromJson(json.decode(str));

String recipeModelToJson(RecipeModel data) => json.encode(data.toJson());

class RecipeModel {
  int id;
  int userId;
  String title;
  String description;
  String cookingMethod;
  String ingredients;
  String photoUrl;
  DateTime createdAt;
  DateTime updatedAt;
  int likesCount;
  int commentsCount;
  User user;

  RecipeModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.cookingMethod,
    required this.ingredients,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.user,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    // Mengambil tanggal dengan aman
    DateTime parseDate(String? dateString) {
      try {
        return dateString != null ? DateTime.parse(dateString) : DateTime.now();
      } catch (e) {
        return DateTime.now(); // Return default date if parsing fails
      }
    }

    return RecipeModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      title: json["title"] ?? "Untitled",
      description: json["description"] ?? "",
      cookingMethod: json["cooking_method"] ?? "",
      ingredients: json["ingredients"] ?? "",
      photoUrl: json["photo_url"] ?? "",
      createdAt: parseDate(json["created_at"]),
      updatedAt: parseDate(json["updated_at"]),
      likesCount: json["likes_count"] ?? 0,
      commentsCount: json["comments_count"] ?? 0,
      user: User.fromJson(json["user"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "cooking_method": cookingMethod,
        "ingredients": ingredients,
        "photo_url": photoUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "likes_count": likesCount,
        "comments_count": commentsCount,
        "user": user.toJson(),
      };
}

class User {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Mengambil tanggal dengan aman dan memastikan emailVerifiedAt bisa null
    DateTime parseDate(String? dateString) {
      try {
        return dateString != null ? DateTime.parse(dateString) : DateTime.now();
      } catch (e) {
        return DateTime.now(); // Return default date if parsing fails
      }
    }

    return User(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Unknown",
      email: json["email"] ?? "No Email",
      emailVerifiedAt: json["email_verified_at"],
      createdAt: parseDate(json["created_at"]),
      updatedAt: parseDate(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class RecipePagination {
  int currentPage;
  List<RecipeModel> recipes;
  String? nextPageUrl;
  String? prevPageUrl;

  RecipePagination({
    required this.currentPage,
    required this.recipes,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory RecipePagination.fromJson(Map<String, dynamic> json) {
    return RecipePagination(
      currentPage: json['current_page'] ?? 1,
      recipes: (json['data'] as List?)
              ?.map((recipe) => RecipeModel.fromJson(recipe))
              .toList() ??
          [],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }
}
