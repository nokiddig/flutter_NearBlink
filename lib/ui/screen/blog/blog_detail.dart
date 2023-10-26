import 'package:blog_app/model/blog.dart';
import 'package:blog_app/model/comment.dart';
import 'package:blog_app/model/like.dart';
import 'package:blog_app/services/save_account.dart';
import 'package:blog_app/ui/screen/blog/edit_blog.dart';
import 'package:blog_app/ui/screen/profile/profile_tab.dart';
import 'package:blog_app/utils/constain/my_const.dart';
import 'package:blog_app/viewmodel/account_viewmodel.dart';
import 'package:blog_app/viewmodel/blog_viewmodel.dart';
import 'package:blog_app/viewmodel/comment_viewmodel.dart';
import 'package:blog_app/viewmodel/like_viewmodel.dart';
import 'package:blog_app/viewmodel/save_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../model/save.dart';

class BlogDetail extends StatefulWidget {
  const BlogDetail({super.key, required this.blog});
  final Blog blog;

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
        ),
        body: Hero(
            tag: "blog-detail-${widget.blog.id}",
            child: ABlogDetail(widget.blog)));
  }
}

class ABlogDetail extends StatefulWidget {
  Blog blog;

  ABlogDetail(this.blog, {super.key});

  @override
  State<ABlogDetail> createState() => _ABlogDetailState();
}

class _ABlogDetailState extends State<ABlogDetail> {
  BlogViewmodel blogViewmodel = BlogViewmodel();
  LikeViewmodel likeViewmodel = LikeViewmodel();
  CommentViewmodel commentViewmodel = CommentViewmodel();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UI_CONST.SIZEDBOX10,
          FutureBuilder(
            future: AccountViewModel().getByEmail(widget.blog.email),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String? avatar = snapshot.data?.avatarPath;
                String? name = snapshot.data?.name;
                String? email = snapshot.data?.email;
                return SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Route route = MaterialPageRoute(
                            builder: (context) =>
                                ProfileTab(email: email ?? ""),
                          );
                          Navigator.push(context, route);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                avatar ?? "",
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  STRING_CONST.IMAGE_DEFAULT,
                                ),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name ?? "name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FONT_CONST.BESTIE.fontFamily)),
                            Text(email ?? "email"),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) {
                          List<PopupMenuEntry> list = [
                            const PopupMenuItem(
                                child: Text("Save"),
                                value: STRING_CONST.VALUE_SAVE)
                          ];
                          if (SaveAccount.currentEmail == email) {
                            list.addAll([
                              const PopupMenuItem(
                                child: Text("Edit"),
                                value: STRING_CONST.VALUE_EDIT,
                              ),
                              const PopupMenuItem(
                                child: Text("Delete"),
                                value: STRING_CONST.VALUE_DELETE,
                              ),
                            ]);
                          }
                          return list;
                        },
                        onSelected: (value) {
                          switch (value) {
                            case STRING_CONST.VALUE_DELETE:
                              this.deleteBlog(context);
                              break;
                            case STRING_CONST.VALUE_EDIT:
                              this.editBlog(context);
                              break;
                            case STRING_CONST.VALUE_SAVE:
                              this.saveBlog();
                              break;
                          }
                        },
                      )
                    ],
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          StreamBuilder<Blog?>(
              stream: blogViewmodel.getById(widget.blog.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Blog blogSnap = snapshot!.data!;
                  return Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).dividerColor)),
                            child: Image.network(blogSnap.image)),
                        Text(blogSnap.title, style: FONT_CONST.TITLE_BLOG),
                        Text(
                          blogSnap.content,
                          style: FONT_CONST.CONTENT_BLOG,
                        ),
                        UI_CONST.SIZEDBOX10,
                        UI_CONST.DIVIDER2,
                        this.buildReaction(),
                        UI_CONST.DIVIDER2,
                        buildComment()
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }

  Container buildComment() {
    return Container(
      constraints: BoxConstraints(maxHeight: 100, minHeight: 50),
      child: StreamBuilder(
        stream: commentViewmodel.getByBlogId(widget.blog.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Comment> list = snapshot.data ?? [];
            print(list.length);
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(),
                title: Text(list[index].content),
                subtitle: Text("}}"),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Read comment Error: ${snapshot.error}");
          } else
            return Text("---");
        },
      ),
    );
  }

  Widget buildReaction() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [buildLikeStream(), VerticalDivider(), buildCommentStream()],
      ),
    );
  }

  Widget buildLikeStream() {
    return Center(
      child: Row(
        children: [
          StreamBuilder(
              stream: likeViewmodel.checkLike(
                  SaveAccount.currentEmail!, widget.blog.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bool isLike = snapshot.data ?? false;
                  IconData icon =
                      isLike == true ? Icons.favorite : Icons.favorite_border;
                  return IconButton(
                    onPressed: () {
                      if (isLike) {
                        likeViewmodel.delete(widget.blog.id);
                      } else {
                        likeViewmodel.add(Like(
                            widget.blog.id,
                            SaveAccount.currentEmail ?? "",
                            Timestamp.fromDate(DateTime.now())));
                      }
                    },
                    icon: Icon(icon),
                    color: Colors.redAccent,
                  );
                }
                return IconButton(
                    onPressed: () {}, icon: Icon(Icons.favorite_border));
              }),
          FutureBuilder(
            future: likeViewmodel.countLike(widget.blog.id),
            builder: (context, snapshot) => Text(snapshot.data.toString()),
          )
        ],
      ),
    );
  }

  Widget buildCommentStream() {
    return Center(
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.comment_outlined),
            color: Colors.blueAccent,
          ),
          Text("1")
        ],
      ),
    );
  }

  void deleteBlog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('You want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                blogViewmodel.delete(widget.blog.id);
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void editBlog(BuildContext context) {
    Route route = MaterialPageRoute(
      builder: (context) => EditBlog(widget.blog),
    );
    Navigator.push(context, route);
  }

  void saveBlog() {
    Timestamp time = Timestamp.fromDate(DateTime.now());
    if (SaveAccount.currentEmail != null)
      SaveViewmodel()
          .add(Save(SaveAccount.currentEmail!, widget.blog.id, time));
  }
}
