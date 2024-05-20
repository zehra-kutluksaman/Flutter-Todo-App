import 'package:cloud_firestore/cloud_firestore.dart';

//CREATE
class DatabaseMethods {
  Future addTodoDetails(Map<String, dynamic> todoInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Todo")
        .doc(id)
        .set(todoInfoMap);
  }

//READ
  Future<Stream<QuerySnapshot>> getTodoDetails() async {
    return await FirebaseFirestore.instance.collection("Todo").snapshots();
  }

//UPDATE
  Future updateTodoDetail(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Todo")
        .doc(id)
        .update(updateInfo);
  }

//DELETE
  Future deleteTodoDetail(String id) async {
    return await FirebaseFirestore.instance.collection("Todo").doc(id).delete();
  }
}
