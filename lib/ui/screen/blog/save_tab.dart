import '../../../ui/screen/blog/blog_detail.dart';
import '../../../utils/constant/my_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../model/blog.dart';
import '../../../model/save.dart';
import '../../../repository/blog_repository.dart';
import '../../../repository/save_repository.dart';

class SaveTab extends StatefulWidget {
  const SaveTab({super.key});

  @override
  State<SaveTab> createState() => _SaveTabState();
}

class _SaveTabState extends State<SaveTab> {
  SaveRepository saveViewmodel = SaveRepository();
  BlogRepository blogViewmodel = BlogRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Save"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: saveViewmodel.getByEmail(),
            builder: (context, snapshot) {
              if (snapshot.hasData){
                List<Save> saveList = snapshot.data ?? [];
                if (saveList.isEmpty){
                  return const Text("You have not saved anything!");
                }
                return ListView.builder(
                  itemCount: saveList.length,
                  itemBuilder: (context, index) {
                    Save save = saveList[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: 200,
                      height: 90,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: StreamBuilder<Blog?>(
                        stream: blogViewmodel.getById(save.blogId),
                        builder: (context, snapshot) {
                          Blog blog = snapshot!.data ?? Blog("id", "title", "content", "", "", "", Timestamp(0,0));
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetail(blog: blog),));
                            },
                            child: Stack(
                              children: [
                                Positioned(
                                  width: 90,
                                    height: 90,
                                    top: 0,
                                    left: 5,
                                    child: Image.network(blog.image,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.network(STRING_CONST.NETWORKIMAGE_DEFAULT);
                                      },)
                                ),
                                Positioned(
                                  top: 10,
                                  left: 100,
                                  child: Text("Blog: ${blog.title}"),),
                                Positioned(
                                  top: 50,
                                  left: 100,
                                  child: Text("Time: ${saveList[index].timestamp.toDate()}"),),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(onPressed: (){
                                      saveViewmodel.delete(save.blogId);
                                    },
                                      icon: Icon(Icons.bookmark_remove_outlined),)
                                )
                              ],
                            ),
                          );
                        }


                      ),
                    );
                  },
                );
              }
              else if(snapshot.hasError){
                return Text("Đã xảy ra lỗi khi đoc save: ${snapshot.error}");
              }
              else{
                return const Center(child: CircularProgressIndicator());
              }
            },),
      ),
    );
  }
}
