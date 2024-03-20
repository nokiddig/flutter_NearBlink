import '../model/notification.dart';
import '../repository/repository.dart';
import '../utils/constant/firebase_model_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRepository extends Repository<Noti>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final NotificationRepository _instance = NotificationRepository._internal();

  factory NotificationRepository() {
    return _instance;
  }

  NotificationRepository._internal();

  @override
  Future<void> add(Noti t) async {
    await _firestore.collection(MODEL_CONST.COLLECTION_NOTIFICATION)
        .add(convertToMap(t));
  }

  @override
  Map<String, dynamic> convertToMap(Noti t) {
    return {
      MODEL_CONST.FIELD_CONTENT: t.content,
      MODEL_CONST.FIELD_EMAIL: t.email,
      MODEL_CONST.FIELD_TIME: t.time,
      MODEL_CONST.FIELD_TYPE: t.type,
      MODEL_CONST.FIELD_INFOMATION: t.information
    };
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> edit(Noti t) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Noti fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Noti(
        data[MODEL_CONST.FIELD_CONTENT],
        data[MODEL_CONST.FIELD_EMAIL],
        data[MODEL_CONST.FIELD_TYPE],
        data[MODEL_CONST.FIELD_TIME],
        data[MODEL_CONST.FIELD_INFOMATION]
    );
  }

  @override
  Future<List<Noti>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  Stream<List<Noti>> getByEmail(String email) {
    return _firestore.collection(MODEL_CONST.COLLECTION_NOTIFICATION)
        .where(MODEL_CONST.FIELD_EMAIL, isEqualTo: email)
        .orderBy(MODEL_CONST.FIELD_TIME, descending: true)
        .snapshots().map((snap) => snap.docs.map((doc) => fromFirestore(doc)).toList());
  }
}