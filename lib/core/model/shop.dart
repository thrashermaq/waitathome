import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop {
  int id;
  String name;
  String email;
  double lat;
  double long;
  int customerInStore;

  Shop(this.id, this.name, this.email, this.lat, this.long,
      this.customerInStore);

  factory Shop.create(String name, String email) =>
      new Shop(null, name, email, 0, 0, 0);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ShopToJson(this);
}
