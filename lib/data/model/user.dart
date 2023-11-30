import 'package:conduit_core/conduit_core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/data/model/saves.dart';
import 'package:soc_backend/data/model/settings.dart';

part 'user.g.dart';

class User extends ManagedObject<_User> implements _User {}

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  fieldRename: FieldRename.snake,
)
@Table(name: 'users', useSnakeCaseColumnName: true)
class _User {
  _User({
    this.email,
    this.name,
    this.id,
    this.refreshToken,
    this.settings,
    this.saves,
  });

  @Column(primaryKey: true, autoincrement: true)
  int? id;
  @Column(nullable: true)
  String? userId;
  @Column()
  String? email;
  @Column()
  String? name;
  @Column()
  String? refreshToken;

  Settings? settings;

  ManagedSet<Save>? saves;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
