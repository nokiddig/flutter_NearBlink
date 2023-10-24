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

  Future<String> genNewId() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(MODEL_CONST.COLLECTION_BLOG)
        .get();
    int id = 0;
    querySnapshot.docs.forEach((element) {
      if(id < int.parse(element.id)){
        id = int.parse(element.id);
      }
    });
    id ++;
    return id.toString();
  }

  @override
  Future<void> add(Blog t) async {
    t.id = await genNewId();
    _firestore.collection(MODEL_CONST.COLLECTION_BLOG).doc(t.id)
        .set(convertToMap(t));
  }

  @override
  Map<String, dynamic> convertToMap(Blog t) {
    return {
      MODEL_CONST.FIELD_EMAIL: t.email,
      MODEL_CONST.FIELD_IMAGE: t.image,
      MODEL_CONST.FIELD_TITLE: t.title,
      MODEL_CONST.FIELD_CONTENT: t.content,
      MODEL_CONST.FIELD_CATEGORYID: t.categoryId
    };
  }

  @override
  Future<void> delete(String str) async {
    try {
      await FirebaseFirestore.instance.collection(MODEL_CONST.COLLECTION_BLOG).doc(str).delete();
    } catch (e) {
      print('Lỗi khi xóa tài liệu: $e');
    }
  }

  @override
  Future<void> edit(Blog t) async {
    _firestore.collection(MODEL_CONST.COLLECTION_BLOG).doc(t.id)
        .set(convertToMap(t));
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
        data[MODEL_CONST.FIELD_CATEGORYID],
    );
  }

  @override
  Future<List<Blog>> getAll() async {
    List<Blog> all = [];
    QuerySnapshot querySnapshot = await _firestore.collection(MODEL_CONST.COLLECTION_BLOG).get();
    querySnapshot.docs.forEach((element) {
      all.add(fromFirestore(element));
    });
    return all;
  }

  @override
  Future<List<Blog>> search(String title) async {
    List<Blog> result = [];
    QuerySnapshot querySnapshot = await _firestore.collection(MODEL_CONST.COLLECTION_BLOG).get();
    querySnapshot.docs.forEach((element) {
      Blog blog = fromFirestore(element);
      if (blog.title.toLowerCase().contains(title.toLowerCase())){
        result.add(blog);
      }
    });
    return result;
  }

  Stream<List<Blog>> getPostsByEmail(String email) {
    return _firestore.collection(MODEL_CONST.COLLECTION_BLOG)
        .where(MODEL_CONST.FIELD_EMAIL, isEqualTo: email)
        .snapshots().map((snapshot) {
          return snapshot.docs.map((doc) {
            Blog blog = fromFirestore(doc);
            return blog;
          }
        ).toList();});
  }

  Stream<Blog?> getById(String id) {
    try {
      return _firestore
          .collection(MODEL_CONST.COLLECTION_BLOG)
          .doc(id)
          .snapshots()
          .map((event) {
        return fromFirestore(event);
      });
    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      return Stream.error(e);
    }
  }

}