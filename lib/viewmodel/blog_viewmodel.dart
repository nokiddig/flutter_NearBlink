import 'package:blog_app/model/blog.dart';
import 'package:blog_app/viewmodel/viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constain/firebase_model_const.dart';

class BlogViewmodel extends ViewModel<Blog>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final BlogViewmodel _instance = BlogViewmodel._internal();

  factory BlogViewmodel() {
    return _instance;
  }

  BlogViewmodel._internal();

  @override
  Future<void> add(Blog t) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> convertToMap(Blog t) {
    // TODO: implement convertToMap
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String str) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> edit(Blog t) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Blog fromFirestore(DocumentSnapshot<Object?> doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Blog(
        doc.id,
        data[MODEL_CONST.FIELD_TITLE],
        data[MODEL_CONST.FIELD_CONTENT],
        data[MODEL_CONST.FIELD_IMAGE],
        data[MODEL_CONST.FIELD_EMAIL],
    );
  }

  @override
  Stream<List<Blog>> getAll() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = _firestore.collection(MODEL_CONST.COLLECTION_BLOG).snapshots();
    if (snapshot.isEmpty == true) {

    }
    return _firestore.collection(MODEL_CONST.COLLECTION_BLOG).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Blog blog = fromFirestore(doc);
        return blog;
      }
      ).toList();
    });
  }

  Future<List<Blog>> getPostsByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(MODEL_CONST.COLLECTION_BLOG)
        .where(MODEL_CONST.FIELD_EMAIL, isEqualTo: email)
        .get();
    List<Blog> result = [];
    querySnapshot.docs.forEach((element) {result.add(fromFirestore(element));});
    return result;
  }
}