import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waitathome/core/model/shop.dart';

class ShopService {
  var databaseReference;

  ShopService() {
    this.databaseReference = Firestore.instance;
  }

  login(String loginCode, void onLoginSuccessful(String shopId),
      void onLoginFailed()) {
    Firestore.instance
        .collection("shop-codes")
        .document(loginCode)
        .get()
        .then((value) {
      if (value.data == null) {
        onLoginFailed();
      } else {
        onLoginSuccessful(value.data["shop-id"]);
      }
    });
  }

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

  void setConsumerInStore(String shopId, int nrOfConsumer) {
    databaseReference
        .collection("shops")
        .document(shopId)
        .updateData({"customerInStore": nrOfConsumer});
  }

  Future<String> register(String shopName) {
    print("register shop with name $shopName");

    var shop = new Shop(null, shopName, 0);

    return databaseReference.collection("shops").add(shop.toJson()).then((ref) {
      return ref.documentID;
    });
  }
}
