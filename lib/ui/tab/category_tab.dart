import 'package:blog_app/model/category.dart';
import 'package:blog_app/ui/screen/item/list_blog.dart';
import 'package:flutter/material.dart';

import '../../repository/blog_repository.dart';
import '../../repository/category_repository.dart';

class CategoryTab extends StatefulWidget {
  static final CategoryTab _instance = CategoryTab._internal();

  factory CategoryTab() {
    return _instance;
  }

  const CategoryTab._internal();

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  CategoryRepository categoryViewmodel = CategoryRepository();
  BlogRepository blogViewmodel = BlogRepository();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: categoryViewmodel.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            List<Category>? list = snapshot.data ?? [];
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 100
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, 
                        MaterialPageRoute(builder: (context) 
                        => ListViewBlogScreen(blogViewmodel.getBlogByCategory(list[index].id)),));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(list[index].image),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        list[index].name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          else if (snapshot.hasError){
            return Text("Loi doc category ${snapshot.error}");
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}
