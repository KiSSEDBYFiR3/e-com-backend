import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/data/model/saves.dart';

part 'saves_response.g.dart';

@JsonSerializable(
  createToJson: true,
  createFactory: false,
  fieldRename: FieldRename.snake,
)
class SavesResponse {
  const SavesResponse(this.saves);
  final List<Save> saves;

  Map<String, dynamic> toJson() => _$SavesResponseToJson(this);
}
