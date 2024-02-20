import 'package:blog_app/model/blog.dart';
import 'package:blog_app/services/save_account.dart';
import 'package:blog_app/utils/constain/my_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../repository/blog_repository.dart';

class EditBlog extends StatefulWidget {
  Blog blog;

  EditBlog(this.blog, {super.key});

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerContent = TextEditingController();
  final TextEditingController _controllerImage = TextEditingController();
  String? _selectedValue;

  @override
  void initState() {
    _controllerImage.text = widget.blog.image;
    _controllerTitle.text = widget.blog.title;
    _controllerContent.text = widget.blog.content;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Blog"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            UI_CONST.SIZEDBOX30,
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: "Blog's title..",
                labelText: "Title",
                icon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              controller: _controllerTitle,
              validator: (value) {
                RegExp regex = RegExp(r'^.{5,200}$');
                if(regex.hasMatch(value ?? "")){
                  return null;
                }
                else {
                  return "At least 8 characters.";
                }
              },
            ),
            UI_CONST.SIZEDBOX15,
            TextFormField(
              scrollController: ScrollController(),
              maxLines: 3,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: "Content",
                labelText: "Content",
                icon: Icon(Icons.content_paste_outlined),
                border: OutlineInputBorder(),

              ),
              controller: _controllerContent,
              validator: (value) {
                RegExp regex = RegExp(r'^.{100,}$');
                if(regex.hasMatch(value ?? "")){
                  return null;
                }
                else {
                  return "At least 100 characters.";
                }
              },
            ),
            UI_CONST.SIZEDBOX15,
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Image address",
                labelText: "Image",
                icon: Icon(Icons.image_outlined),
                border: OutlineInputBorder(),
              ),
              controller: _controllerImage,
              validator: (value) {

              },
            ),
            UI_CONST.SIZEDBOX15,
            DropdownButton<String>(
              icon: const Icon(Icons.category_outlined),
              style: const TextStyle(
                color: Colors.black,
              ),
              hint: const Text("Category"),
              value: _selectedValue,
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: '1',
                  child: Text('Technology'),
                ),
                DropdownMenuItem<String>(
                  value: '2',
                  child: Text('Science'),
                ),
                DropdownMenuItem<String>(
                  value: '3',
                  child: Text('Android'),
                ),
                DropdownMenuItem<String>(
                  value: '4',
                  child: Text('IOS'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: (){
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  editBlog();
                  Navigator.pop(context);
                }
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }

  void editBlog() {
    String title = _controllerTitle.text;
    String content = _controllerContent.text;
    String image = _controllerImage.text;
    BlogRepository viewmodel = BlogRepository();
    viewmodel.edit(Blog(widget.blog.id, title, content, image, SaveAccount.currentEmail?? ""
        , _selectedValue??'1', Timestamp.fromDate(DateTime.now())));
  }
}