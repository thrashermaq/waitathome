import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waitathome/core/model/login_code.dart';
import 'package:waitathome/core/model/shop.dart';

class ShopService {
  static const SHOPS_TABLE_NAME = "shops";
  static const SHOP_CODES_TABLE_NAME = "shop-codes";

  var databaseReference;

  ShopService() {
    this.databaseReference = Firestore.instance;
  }

  loadAll(void onLoaded(List<Shop> shops)) {
    databaseReference
        .collection(SHOPS_TABLE_NAME)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      List<Shop> shops =
          snapshot.documents.map((f) => Shop.fromJson(f.data)).toList();
      onLoaded(shops);
    });
  }

  login(String loginCode, void onLoginSuccessful(String shopId),
      void onLoginFailed()) {
    databaseReference
        .collection(SHOP_CODES_TABLE_NAME)
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

  getShop(String id) {
    return databaseReference
        .collection(SHOPS_TABLE_NAME)
        .document(id)
        .snapshots();
  }

  void setConsumerInStore(String shopId, int nrOfConsumer) {
    print('Update store with id: $shopId with $nrOfConsumer consumers');
    databaseReference
        .collection(SHOPS_TABLE_NAME)
        .document(shopId)
        .updateData({"customerInStore": nrOfConsumer});
  }

  void setLimit(String shopId, int limit) {
    databaseReference
        .collection(SHOPS_TABLE_NAME)
        .document(shopId)
        .updateData({"limit": limit});
  }

  void setQueue(String shopId, int queue) {
    databaseReference
        .collection(SHOPS_TABLE_NAME)
        .document(shopId)
        .updateData({"queue": queue});
  }

  void setQueueEnabled(String shopId, bool isEnabled) {
    databaseReference
        .collection(SHOPS_TABLE_NAME)
        .document(shopId)
        .updateData({"queueEnabled": isEnabled});
  }

  void setActiveButton(String shopId, List<bool> activeButton) {
    databaseReference
        .collection(SHOPS_TABLE_NAME)
        .document(shopId)
        .updateData({"activeButton": activeButton});
  }

  Future register(String shopName, String email) {
    print("register shop with name $shopName");
    var shop = Shop.create(shopName, email);

    return saveShop(shop).then((shopId) {
      return addShopLoginCode(shopId);
    });
  }

  Future saveShop(Shop shop) {
    return databaseReference
        .collection(SHOPS_TABLE_NAME)
        .add(shop.toJson())
        .then((ref) => ref.documentID);
  }

  Future addShopLoginCode(String shopId) async {
    var generatedCode = LoginCode.generate();

    var loginCodeEx = await existsLoginCode(generatedCode);
    print("loginCodeexists $loginCodeEx");
    if (loginCodeEx) {
      print("generated login code already exists, try generate again");
      return addShopLoginCode(shopId);
    }

    return databaseReference
        .collection(SHOP_CODES_TABLE_NAME)
        .document(generatedCode.toString())
        .setData({"shop-id": shopId}).then((ref) => generatedCode);
  }

  Future<bool> existsLoginCode(int loginCode) {
    return databaseReference
        .collection(SHOP_CODES_TABLE_NAME)
        .document(loginCode.toString())
        .get()
        .then<bool>((value) {
      print("value $value");
      return value.data != null;
    });
  }
}
