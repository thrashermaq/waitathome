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
      List<Shop> shops = snapshot.documents.map((f) {
        print(f.data);
        return Shop.fromJson(f.data);
      }).toList();
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

  void getShop(String id, void onShopUpdate(Shop event)) {
    databaseReference
        .collection(SHOPS_TABLE_NAME)
        .document(id)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> shopDto = documentSnapshot.data;
      onShopUpdate(Shop.fromJson(shopDto));
    }).onError((e) => print(e));
  }

  void setConsumerInStore(String shopId, int nrOfConsumer) {
    databaseReference
        .collection(SHOPS_TABLE_NAME)
        .document(shopId)
        .updateData({"customerInStore": nrOfConsumer});
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
