import 'package:blog_app/model/blog.dart';
import 'package:blog_app/ui/screen/blog/blog_detail.dart';
import 'package:blog_app/utils/constant/my_const.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../repository/blog_repository.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final BlogRepository viewmodel = BlogRepository();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
                height: 150,
                child: Center(child: Lottie.network("https://lottie.host/a7ff454c-f78a-41d1-a71f-a43277f5494e/o55QYBhiwd.json"))),
            Text("Highlight", style: FONT_CONST.SESSION,),
            Highlight(viewmodel: viewmodel,),
            Text("Feed", style: FONT_CONST.SESSION,),
            NewFeed(viewmodel: viewmodel)
          ],
        ),
      ),
    );
  }
}

class Highlight extends StatelessWidget {
  final BlogRepository viewmodel;

  const Highlight({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: FutureBuilder<List<Blog>>(
        future: viewmodel.highlight(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Blog blog = snapshot.data![index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetail(blog: blog),));
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(blog.image,
                              ),
                              fit: BoxFit.cover,
                              opacity: 0.9
                              ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                          left: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white.withOpacity(0.8),
                              boxShadow:  [BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // changes position of shadow
                              )]
                            ),
                            //color: Colors.white,
                            width: 80,
                              child: Text(blog.title,
                                overflow: TextOverflow.ellipsis,
                              )
                          )
                      )
                    ]
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("Đã xảy ra lỗi: ${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class NewFeed extends StatelessWidget {
  final BlogRepository viewmodel;

  const NewFeed({
    super.key,
    required this.viewmodel,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: viewmodel.getAll(),
        builder: (context, snapshot) {
          List<Blog> data = snapshot.data ?? [];
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              Blog blog = data[index];
              return ABlogDetail(blog);
              return Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: SizedBox(
                  height: 70,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetail(blog: blog),));
                    },
                    child: Hero(
                      tag: "blog-detail-${blog.id}",
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              // height: 90,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(blog.image,),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(blog.title, style: FONT_CONST.TITLE_BLOG),
                                      Text(blog.content, style: FONT_CONST.CONTENT_BLOG,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },);
        },
    );
  }
}
