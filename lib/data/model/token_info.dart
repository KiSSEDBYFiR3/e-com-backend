import 'package:json_annotation/json_annotation.dart';

part 'token_info.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
  fieldRename: FieldRename.snake,
)
class TokenInfo {
  const TokenInfo({
    required this.name,
    required this.sub,
    this.pitcure,
  });
  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);

  final String name;
  final String sub;
  final String? pitcure;

  Map<String, dynamic> toJson() => _$TokenInfoToJson(this);
}
