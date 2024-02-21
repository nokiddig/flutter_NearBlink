import 'package:blog_app/model/blog.dart';
import 'package:blog_app/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constant/firebase_model_const.dart';

class BlogRepository extends Repository<Blog> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final BlogRepository _instance = BlogRepository._internal();

  factory BlogRepository() {
    return _instance;
  }

  BlogRepository._internal();

  Future<String> genNewId() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(MODEL_CONST.COLLECTION_BLOG).get();
    int id = 0;
    querySnapshot.docs.forEach((element) {
      if (id < int.parse(element.id)) {
        id = int.parse(element.id);
      }
    });
    id++;
    return id.toString();
  }

  @override
  Future<void> add(Blog t) async {
    try {
      t.id = await genNewId();
      await _firestore
          .collection(MODEL_CONST.COLLECTION_BLOG)
          .doc(t.id)
          .set(convertToMap(t));
    } catch (e) {
      return;
    }
  }

  @override
  Map<String, dynamic> convertToMap(Blog t) {
    return {
      MODEL_CONST.FIELD_EMAIL: t.email,
      MODEL_CONST.FIELD_IMAGE: t.image,
      MODEL_CONST.FIELD_TITLE: t.title,
      MODEL_CONST.FIELD_CONTENT: t.content,
      MODEL_CONST.FIELD_CATEGORYID: t.categoryId,
      MODEL_CONST.FIELD_TIME: t.time
    };
  }

  @override
  Future<void> delete(String str) async {
    try {
      await FirebaseFirestore.instance
          .collection(MODEL_CONST.COLLECTION_BLOG)
          .doc(str)
          .delete();
    } catch (e) {
      print('Lỗi khi xóa tài liệu: $e');
    }
  }

  @override
  Future<void> edit(Blog t) async {
    _firestore
        .collection(MODEL_CONST.COLLECTION_BLOG)
        .doc(t.id)
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
      data[MODEL_CONST.FIELD_TIME]
    );
  }

  @override
  Future<List<Blog>> getAll() async {
    List<Blog> all = [];
    QuerySnapshot querySnapshot =
        await _firestore.collection(MODEL_CONST.COLLECTION_BLOG)
            .orderBy(MODEL_CONST.FIELD_TIME, descending: true)
            .get();
    querySnapshot.docs.forEach((element) {
      all.add(fromFirestore(element));
    });
    return all;
  }

  @override
  Future<List<Blog>> search(String title) async {
    List<Blog> result = [];
    QuerySnapshot querySnapshot =
        await _firestore.collection(MODEL_CONST.COLLECTION_BLOG).get();
    querySnapshot.docs.forEach((element) {
      Blog blog = fromFirestore(element);
      if (blog.title.toLowerCase().contains(title.toLowerCase())) {
        result.add(blog);
      }
    });
    return result;
  }

  Stream<List<Blog>> getBlogsByEmail(String email) {
    return _firestore
        .collection(MODEL_CONST.COLLECTION_BLOG)
        .where(MODEL_CONST.FIELD_EMAIL, isEqualTo: email)
        .orderBy(FieldPath.documentId, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Blog blog = fromFirestore(doc);
        return blog;
      }).toList();
    });
  }

  @override
  Future<List<Blog>> getBlogByCategory(String categoryId) async {
    List<Blog> result = [];
    QuerySnapshot querySnapshot =
      await _firestore.collection(MODEL_CONST.COLLECTION_BLOG)
        .where(MODEL_CONST.FIELD_CATEGORYID, isEqualTo: categoryId)
        .orderBy(FieldPath.documentId, descending: true)
        .get();
    querySnapshot.docs.forEach((element) {
      Blog blog = fromFirestore(element);
        result.add(blog);
    });
    return result;
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

  @override
  Future<List<Blog>> highlight() async {
    List<Blog> result = [];
    QuerySnapshot querySnapshot =
    await _firestore.collection(MODEL_CONST.COLLECTION_BLOG)
        .orderBy(MODEL_CONST.FIELD_TIME, descending: false)
        .get();
    querySnapshot.docs.forEach((element) {
      result.add(fromFirestore(element));
    });
    return result;
  }
}
