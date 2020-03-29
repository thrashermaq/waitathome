import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

// TODO: WTF?
GeoPoint _geopointToJson(GeoPoint json) => json;
GeoPoint _geopointFromJson(GeoPoint json) => json;

@JsonSerializable()
class Shop {
  String id;
  String name;
  String email;
  @JsonKey(fromJson: _geopointFromJson, toJson: _geopointToJson)
  GeoPoint location;
  int customerInStore;
  int limit;
  int queue;

  Shop(this.id, this.name, this.email, this.location, this.customerInStore,
      this.limit, this.queue);

  factory Shop.create(String name, String email, GeoPoint geoPoint) =>
      // TODO limit mit input befüllen
      new Shop(null, name, email, geoPoint, 0, 50, 0);

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson() => _$ShopToJson(this);
}
