import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:ecom_backend/data/model/product_model_dto.dart';
import 'package:ecom_backend/ecom_backend.dart';
import 'package:ecom_backend/util/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_response_dto.g.dart';

@JsonSerializable(
  createToJson: true,
  createFactory: true,
  fieldRename: FieldRename.snake,
)
class CartResponseDto implements Serializable {
  const CartResponseDto({
    required this.id,
    required this.price,
    required this.products,
  });

  factory CartResponseDto.fromJson(Json json) =>
      _$CartResponseDtoFromJson(json);

  final int? id;

  final String? price;

  final List<ProductModelDto>? products;

  @override
  Map<String, dynamic> asMap() => _$CartResponseDtoToJson(this);

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object(
      {
        "id": APISchemaObject.integer(),
        "price": APISchemaObject.string(),
        "products": APISchemaObject.array(
          ofSchema: const ProductModelDto().documentSchema(context),
        )
      },
    );
  }

  @override
  void read(Map<String, dynamic> object,
          {Iterable<String>? accept,
          Iterable<String>? ignore,
          Iterable<String>? reject,
          Iterable<String>? require}) =>
      readFromMap(object);

  @override
  void readFromMap(Map<String, dynamic> object) =>
      CartResponseDto.fromJson(object);
}
