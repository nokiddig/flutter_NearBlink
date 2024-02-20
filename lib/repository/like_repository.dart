import 'package:blog_app/model/like.dart';
import 'package:blog_app/repository/repository.dart';
import 'package:blog_app/services/save_account.dart';
import 'package:blog_app/utils/constain/firebase_model_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeRepository extends Repository<Like>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final LikeRepository _instance = LikeRepository._internal();

  factory LikeRepository() {
    return _instance;
  }

  LikeRepository._internal();
  
  @override
  Future<void> add(Like t) async {
    await _firestore.collection(MODEL_CONST.COLLECTION_LIKE)
    .doc('${SaveAccount.currentEmail},${t.blogId}')
    .set(convertToMap(t));
  }

  @override
  Map<String, dynamic> convertToMap(Like t) {
    return {
      MODEL_CONST.FIELD_BLOGID: t.blogId,
      MODEL_CONST.FIELD_EMAIL: t.email,
      MODEL_CONST.FIELD_TIME: t.time
    };
  }

  @override
  Future<void> delete(String blogId) async {
    await _firestore
        .collection(MODEL_CONST.COLLECTION_LIKE)
        .doc('${SaveAccount.currentEmail},$blogId')
        .delete();
  }

  @override
  Future<void> edit(Like t) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Like fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Like(
      data[MODEL_CONST.FIELD_BLOGID],
      data[MODEL_CONST.FIELD_EMAIL],
      data[MODEL_CONST.FIELD_TIME],
    );
  }

  @override
  Future<List<Like>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  
  Stream<int> countLike(String blogId) {
    return _firestore
        .collection(MODEL_CONST.COLLECTION_LIKE)
        .where(MODEL_CONST.FIELD_BLOGID, isEqualTo: blogId)
        .snapshots().map((event) => event.size);
  }

  Stream<bool> checkLike(String email, String blogId) {
    return _firestore.collection(MODEL_CONST.COLLECTION_LIKE)
        .where(MODEL_CONST.FIELD_EMAIL, isEqualTo: email)
        .where(MODEL_CONST.FIELD_BLOGID, isEqualTo: blogId)
        .snapshots().map((event) => event.size>0);
  }
}