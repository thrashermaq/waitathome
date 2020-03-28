import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waitathome/core/model/shop.dart';

class ShopService {
  var databaseReference;

  ShopService() {
    this.databaseReference = Firestore.instance;
  }

  void getShop(String id, void onShopUpdate(Shop event)) {
    databaseReference
        .collection("shops")
        .document(id)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> shopDto = documentSnapshot.data;
      onShopUpdate(Shop.fromJson(shopDto));
    }).onError((e) => print(e));
  }

  void addCustomer(String shopId) {
    changeCustomerBy(1, shopId);
  }

  void removeCustomer(String shopId) {
    changeCustomerBy(-1, shopId);
  }

  void changeCustomerBy(int amount, String shopId) {
    databaseReference.collection("shops")
        .document(shopId)
        .updateData({"customers": FieldValue.increment(amount)});
  }
}
