import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

// TODO: WTF?
GeoPoint _geopointToJson(GeoPoint json) => json;
GeoPoint _geopointFromJson(GeoPoint json) => json;

@JsonSerializable()
class Shop {
  int id;
  String name;
  String email;
  @JsonKey(fromJson: _geopointFromJson, toJson: _geopointToJson)
  GeoPoint location;
  int customerInStore;

  Shop(this.id, this.name, this.email, this.location, this.customerInStore);

  factory Shop.create(String name, String email) =>
      new Shop(null, name, email, null, 0);

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);
}
