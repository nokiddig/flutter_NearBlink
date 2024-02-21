import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Repository<T>{
  T fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc);
  Map<String, dynamic> convertToMap(T t);
  Future<void> add(T t);
  Future<List<T>> getAll();
  Future<void> delete(String str);
  Future<void> edit(T t);
}