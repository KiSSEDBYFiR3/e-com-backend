import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:ecom_backend/ecom_backend.dart';
import 'package:ecom_backend/util/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model_dto.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: true,
  createFactory: true,
)
class ProductModelDto implements Serializable {
  const ProductModelDto({
    this.category,
    this.description,
    this.id,
    this.image,
    this.price,
    this.title,
  });
  factory ProductModelDto.fromJson(Json json) =>
      _$ProductModelDtoFromJson(json);

  final int? id;

  final String? image;

  final String? description;

  final String? title;

  final num? price;

  final String? category;

  Json toJson() => _$ProductModelDtoToJson(this);

  @override
  Map<String, dynamic> asMap() => toJson();

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      'id': APISchemaObject.integer(),
      'image': APISchemaObject.string(),
      'description': APISchemaObject.string(),
      'title': APISchemaObject.string(),
      'price': APISchemaObject.string(),
      'category': APISchemaObject.string(),
    });
  }

  @override
  void read(Map<String, dynamic> object,
          {Iterable<String>? accept,
          Iterable<String>? ignore,
          Iterable<String>? reject,
          Iterable<String>? require}) =>
      ProductModelDto.fromJson(object);

  @override
  void readFromMap(Map<String, dynamic> object) => read(object);
}
