import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/recipe_model.dart';
import 'package:flutter_application_4/service/recipe_service.dart';
import 'package:flutter_application_4/ui/detail_page.dart';
import 'package:flutter_application_4/ui/upload_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final RecipeService _recipeService = RecipeService();
  late Future<List<RecipeModel>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = _recipeService.getAllRecipe();
  }

  void _refreshRecipes() {
    setState(() {
      futureRecipes = _recipeService.getAllRecipe(); // Refresh daftar resep
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadRecipeScreen(
                    onRecipeCreated: _refreshRecipes, // Menambahkan callback
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<RecipeModel>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Gagal load data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Tidak ada data"));
          } else {
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return CustomCard(
                  id: recipe.id,
                  img: recipe.photoUrl,
                  title: recipe.title,
                  likes_count: recipe.likesCount,
                  comments_count: recipe.commentsCount,
                  onDelete: () async {
                    try {
                      await _recipeService.deleteRecipe(recipe.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Recipe deleted successfully")));

                      // Refresh UI after deleting
                      _refreshRecipes();
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadRecipeScreen(
                          recipe: recipe, // Send the recipe data to be edited
                          onRecipeCreated: _refreshRecipes,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String img;
  final String title;
  final int likes_count;
  final int comments_count;
  final int id;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CustomCard({
    required this.id,
    required this.img,
    required this.title,
    required this.likes_count,
    required this.comments_count,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(recipeId: id),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Image.network(
              img,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
