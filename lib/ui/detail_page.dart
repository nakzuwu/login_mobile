import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/recipe_model.dart';
import 'package:flutter_application_4/service/recipe_service.dart';

class DetailPage extends StatefulWidget {
  final int recipeId;

  const DetailPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
  }
    
class _DetailPageState extends State<DetailPage> {
  final RecipeService _recipeService = RecipeService();
  late Future<RecipeModel> futureRecipeDetail;

  @override
  void initState() {
    super.initState();
    futureRecipeDetail = _recipeService.getRecipeDetail(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Detail"),
      ),
      body: FutureBuilder<RecipeModel>(
        future: futureRecipeDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Recipe not found"));
          } else {
            final recipe = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    recipe.photoUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          recipe.title,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),

                        // Likes and Comments
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                SizedBox(width: 4),
                                Text("${recipe.likesCount} likes"),
                              ],
                            ),
                            SizedBox(width: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.comment,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text("${recipe.commentsCount} comments"),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Description
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(recipe.description),

                        SizedBox(height: 16),

                        // Ingredients
                        Text(
                          "Ingredients",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(recipe.ingredients),

                        SizedBox(height: 16),

                        // Cooking Steps
                        Text(
                          "Steps",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(recipe.cookingMethod),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
