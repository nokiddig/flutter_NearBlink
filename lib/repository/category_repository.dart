import 'package:blog_app/model/category.dart';
import 'package:blog_app/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constant/firebase_model_const.dart';

class CategoryRepository extends Repository<Category>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CategoryRepository _instance = CategoryRepository._internal();

  factory CategoryRepository() {
    return _instance;
  }

  CategoryRepository._internal();

  Future<String> genNewId() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(MODEL_CONST.COLLECTION_CATEGORY)
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
  Future<void> add(Category t) async {
    t.id = await genNewId();
    _firestore.collection(MODEL_CONST.COLLECTION_CATEGORY).doc(t.id)
        .set(convertToMap(t));
  }

  @override
  Map<String, dynamic> convertToMap(Category t) {
    return {
      MODEL_CONST.FIELD_IMAGE: t.image,
      MODEL_CONST.FIELD_NAME: t.name,
      MODEL_CONST.FIELD_DESCRIPTION: t.description,
    };
  }

  @override
  Future<void> delete(String str) async {
    try {
      await FirebaseFirestore.instance.collection(MODEL_CONST.COLLECTION_CATEGORY).doc(str).delete();
    } catch (error) {
      print('Lỗi khi xóa tài liệu: $error');
    }
  }

  @override
  Future<void> edit(Category t) async {
    _firestore.collection(MODEL_CONST.COLLECTION_CATEGORY).doc(t.id)
        .set(convertToMap(t));
  }

  @override
  Category fromFirestore(DocumentSnapshot<Object?> doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      doc.id,
      data[MODEL_CONST.FIELD_NAME],
      data[MODEL_CONST.FIELD_DESCRIPTION],
      data[MODEL_CONST.FIELD_IMAGE],
    );
  }

  @override
  Future<List<Category>> getAll() async {
    List<Category> all = [];
    QuerySnapshot querySnapshot = await _firestore.collection(MODEL_CONST.COLLECTION_CATEGORY).get();
    querySnapshot.docs.forEach((element) {
      all.add(fromFirestore(element));
    });
    return all;
  }

  Stream<Category?> getById(String id) {
    try {
      return _firestore
          .collection(MODEL_CONST.COLLECTION_CATEGORY)
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