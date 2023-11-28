import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/data/model/user.dart';
import 'package:soc_backend/soc_backend.dart';

part 'saves.g.dart';

class Save extends ManagedObject<_Save> implements _Save {}

@JsonSerializable(
  createToJson: true,
  createFactory: false,
  fieldRename: FieldRename.snake,
)
@Table(name: 'saves', useSnakeCaseColumnName: true)
class _Save {
  _Save({
    this.batchId = '',
    this.savedPageNum = '',
    this.id,
  });

  @Column(primaryKey: true, autoincrement: true)
  final int? id;

  @Column()
  String batchId;

  @Column()
  String savedPageNum;

  @Relate(#saves)
  User? user;

  Map<String, dynamic> toJson() => _$SaveToJson(this);
}
