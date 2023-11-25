import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/data/model/page.dart';

part 'pages_response.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  fieldRename: FieldRename.snake,
)
class PagesResponse {
  const PagesResponse({
    required this.pages,
    required this.nextPagesBatch,
    required this.currentScenarySoundtrack,
  });

  final List<Page> pages;

  final String nextPagesBatch;

  final String currentScenarySoundtrack;

  Map<String, dynamic> toJson() => _$PagesResponseToJson(this);
}
