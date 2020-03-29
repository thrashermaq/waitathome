import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waitathome/core/model/login_code.dart';
import 'package:waitathome/core/model/shop.dart';
import 'package:waitathome/core/model/shop_identifier.dart';

class ShopService {
  static const SHOPS_TABLE_NAME = "shops";
  static const SHOP_CODES_TABLE_NAME = "shop-codes";

  loadAll(void onLoaded(List<Shop> shops)) {
    Firestore.instance
        .collection(SHOPS_TABLE_NAME)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      List<Shop> shops = snapshot.documents.map((document) {
        var shop = Shop.fromJson(document.data);
        shop.id = document.documentID;
        return shop;
      }).toList();
      onLoaded(shops);
    });
  }

  Stream<QuerySnapshot> getShops() {
    return Firestore.instance.collectionGroup(SHOPS_TABLE_NAME).snapshots();
  }

  login(String loginCode, void onLoginSuccessful(String shopId),
      void onLoginFailed()) {
    Firestore.instance
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
    return Firestore.instance
        .collection(SHOPS_TABLE_NAME)
        .document(id)
        .snapshots();
  }

  void setConsumerInStore(String shopId, int nrOfConsumer) {
    print('Update store with id: $shopId with $nrOfConsumer consumers');
    Firestore.instance
        .collection(SHOPS_TABLE_NAME)
        .document(shopId)
        .updateData({"customerInStore": nrOfConsumer});
  }

  void setLimit(String shopId, int limit) {
    Firestore.instance
        .collection(SHOPS_TABLE_NAME)
        .document(shopId)
        .updateData({"limit": limit});
  }

  void setQueue(String shopId, int queue) {
    Firestore.instance
        .collection(SHOPS_TABLE_NAME)
        .document(shopId)
        .updateData({"queue": queue});
  }

  Future<ShopIdentifier> register(
      String shopName, String email, GeoPoint geoPoint) {
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
    var shop = Shop.create(shopName, email, geoPoint);

    return saveShop(shop).then((shopId) {
      return addShopLoginCode(shopId)
          .then((loginCode) => ShopIdentifier(loginCode, shopId));
    });
  }

  Future saveShop(Shop shop) {
    return Firestore.instance
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

    return Firestore.instance
        .collection(SHOP_CODES_TABLE_NAME)
        .document(generatedCode.toString())
        .setData({"shop-id": shopId}).then((ref) => generatedCode);
  }

  Future<bool> existsLoginCode(String loginCode) {
    return Firestore.instance
        .collection(SHOP_CODES_TABLE_NAME)
        .document(loginCode.toString())
        .get()
        .then<bool>((value) {
      print("value $value");
      return value.data != null;
    });
  }
}
