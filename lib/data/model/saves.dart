import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/soc_backend.dart';

part 'saves.g.dart';

class Save extends ManagedObject<_Save> implements _Save {}

@JsonSerializable(
  createToJson: true,
  createFactory: true,
  fieldRename: FieldRename.snake,
)
@Table(name: 'saves', useSnakeCaseColumnName: true)
class _Save {
  _Save({
    this.batchId = '',
    this.savedPageNum = '',
    this.id,
    this.userId = '',
  });

  @Column(primaryKey: true, autoincrement: true)
  final int? id;

  @Column()
  String userId;

  @Column()
  String batchId;

  @Column()
  String savedPageNum;

  Map<String, dynamic> toJson() => _$SaveToJson(this);

  factory _Save.fromJson(Map<String, dynamic> json) => _$SaveFromJson(json);
}
