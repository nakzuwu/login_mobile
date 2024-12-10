import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_4/models/recipe_model.dart';
import 'package:flutter_application_4/service/recipe_service.dart';
import 'package:flutter_application_4/ui/detail_page.dart';

class HomePage extends StatelessWidget {
  final RecipeService _recipeService = RecipeService();
  late Future<List<RecipeModel>> futureRecipes;
  void getData(){
    try{
      futureRecipes = _recipeService.getAllRecipe();
    } catch (e){
      print(e);
    }
  }
  HomePage() {
    futureRecipes = _recipeService.getAllRecipe(); // Initialize here
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(onPressed: (){}, icon: Icon(Icons.sync),),
      appBar: AppBar(
        title: Text('INI HOME'),
      ),
      body: FutureBuilder<List<RecipeModel>>(
          future: futureRecipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Gagal load data : ${snapshot.error}"),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("Tidak ada data"),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final recipe = snapshot.data![index];
                  return CustomCard(
                      id: recipe.id,
                      img: recipe.photoUrl,
                      title: recipe.title,
                      likes_count: recipe.likesCount,
                      comments_count: recipe.commentsCount);
                },
              );
            }
          }),
    );
  }
}


class CustomCard extends StatelessWidget {
  final String img;
  final String title;
  final int likes_count;
  final int comments_count;
  final int id;
  const CustomCard({
    required this.id,
    required this.img,
    required this.title,
    required this.likes_count,
    required this.comments_count,
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
              "$img",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 100,
            ),
            Text(
              "$title",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 4),
                    Text("$likes_count"),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.comment,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text("$comments_count"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
