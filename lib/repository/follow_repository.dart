import 'package:blog_app/model/follow.dart';
import 'package:blog_app/repository/repository.dart';
import 'package:blog_app/services/save_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constant/my_const.dart';

class FollowRepository extends Repository<Follow>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FollowRepository _instance = FollowRepository._internal();

  factory FollowRepository() {
    return _instance;
  }

  FollowRepository._internal();

  @override
  Future<void> add(Follow t) async {
    await _firestore.collection(MODEL_CONST.COLLECTION_FOLLOW)
        .doc("${t.followerEmail},${t.followingEmail}")
        .set(convertToMap(t));
  }

  @override
  Map<String, dynamic> convertToMap(Follow t) {
    return {
      MODEL_CONST.FIELD_FOLLOWEREMAIL: t.followerEmail,
      MODEL_CONST.FIELD_FOLLOWINGEMAIL: t.followingEmail
    };
  }

  @override
  Future<void> delete(String str) async {
    try {
      await _firestore.collection(MODEL_CONST.COLLECTION_FOLLOW).doc("${SaveAccount.currentEmail},${str}").delete();
    } catch (error) {
      print('Lỗi khi unfollow: $error');
    }
  }

  @override
  Future<void> edit(Follow t) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Follow fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Follow(
      doc.id,
      data[MODEL_CONST.FIELD_FOLLOWEREMAIL],
      data[MODEL_CONST.FIELD_FOLLOWINGEMAIL],
    );
  }

  @override
  Future<List<Follow>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  Stream<List<Follow>> getFollowerByEmail(String email) {
    return _firestore.collection(MODEL_CONST.COLLECTION_FOLLOW)
        .where(MODEL_CONST.FIELD_FOLLOWINGEMAIL, isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) {
        return fromFirestore(e);
      }).toList();
    });
  }

  Stream<int> countFollower(email){
    return _firestore.collection(MODEL_CONST.COLLECTION_FOLLOW)
        .where(MODEL_CONST.FIELD_FOLLOWINGEMAIL, isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) {
        return fromFirestore(e);
      }).toList().length;
    });
  }
  Stream<int> countFollowing(email){
    return _firestore.collection(MODEL_CONST.COLLECTION_FOLLOW)
        .where(MODEL_CONST.FIELD_FOLLOWEREMAIL, isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) {
        return fromFirestore(e);
      }).toList().length;
    });
  }

  Stream<bool> checkFollow(String followerEmail, String followingEmail) {
    return _firestore.collection(MODEL_CONST.COLLECTION_FOLLOW)
        .where(MODEL_CONST.FIELD_FOLLOWEREMAIL, isEqualTo: followerEmail)
        .where(MODEL_CONST.FIELD_FOLLOWINGEMAIL, isEqualTo: followingEmail)
        .snapshots().map((event) => event.size>0);
  }
}