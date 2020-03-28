// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return Shop(
    json['id'] as int,
    json['name'] as String,
    json['customers'] as int,
  );
}

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'customers': instance.customers,
    };
