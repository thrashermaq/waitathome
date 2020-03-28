import 'package:waitathome/core/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waitathome/core/model/shop.dart';

class ShopService {
  var databaseReference;

  ShopService() {
    this.databaseReference = Firestore.instance;
  }

  static Model getModel() => Model(10, 'Test');

  void getShop(String id, void onShop(Shop event)) {
    databaseReference
        .collection("shops")
        .document(id)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> shopDto = documentSnapshot.data;
      onShop(Shop.fromJson(shopDto));
    }).onError((e) => print(e));
  }
}
