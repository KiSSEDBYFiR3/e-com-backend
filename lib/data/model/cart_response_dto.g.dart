// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponseDto _$CartResponseDtoFromJson(Map<String, dynamic> json) =>
    CartResponseDto(
      id: json['id'] as int?,
      price: json['price'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModelDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartResponseDtoToJson(CartResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'products': instance.products,
    };
