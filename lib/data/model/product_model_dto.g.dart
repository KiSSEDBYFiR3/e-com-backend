// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModelDto _$ProductModelDtoFromJson(Map<String, dynamic> json) =>
    ProductModelDto(
      category: json['category'] as String?,
      description: json['description'] as String?,
      id: json['id'] as int?,
      image: json['image'] as String?,
      price: json['price'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$ProductModelDtoToJson(ProductModelDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'description': instance.description,
      'title': instance.title,
      'price': instance.price,
      'category': instance.category,
    };
