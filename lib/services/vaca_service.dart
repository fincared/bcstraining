import 'package:cloud_firestore/cloud_firestore.dart';

class VacaService {

  static String collectionName = "Vaca";
  static CollectionReference collectionRef =
  Firestore.instance.collection(collectionName);

  static getList() {
    return collectionRef.snapshots();
  }

  static add(data) async {
    DateTime now = DateTime.now();

    data['createdUserEmail']='created Email';
    data['updatedUserEmail'] = '';
    data['created'] = now.toString();
    data['updated'] = now.toString();

    collectionRef.add(data).then((r) {
      print('added in cloud too ' + data['img']);
      print(r.documentID);
    }).catchError((error) {
      print('add: $error');
    });

  }

  static delete(String id) {
    collectionRef.document(id).delete().then((r) {
      print('deleted in cloud too');
    }).catchError((error) {
      print('delete: $error');
    });
  }


  static update(String id, data) {
    DateTime now = DateTime.now();
    //data['createdUserEmail']='created Email';
    data['updatedUserEmail'] = 'updated Email';
    // data['created'] = '12/8/2010';
    data['updated'] = now.toString();
    Firestore.instance.runTransaction((Transaction transaction) async {
      await collectionRef.document(id).updateData(data).then((r) {
        print('updated in cloud too');
      }).catchError((error) {
        print('update: $error');
      });
    }).then((mapData) {
      print('Internet ok');
    }).catchError((error) {
      print('No Internet: $error');
    });
  }
}
