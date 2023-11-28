import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/data/model/user.dart';
import 'package:soc_backend/soc_backend.dart';

part 'settings.g.dart';

class Settings extends ManagedObject<_Settings> implements _Settings {}

@JsonSerializable(
  createToJson: true,
  createFactory: false,
  fieldRename: FieldRename.snake,
)
@Table(name: 'settings', useSnakeCaseColumnName: true)
class _Settings {
  _Settings({
    this.volumeLevel = 100,
    this.id = '',
    this.pagesChangeEffect = 'none',
    this.dialoguesWindowType = 'bottomBarLike',
    this.staticText = true,
    this.textGrowthSpeed = 0,
  });

  @Column(primaryKey: true)
  final String id;

  @Column(nullable: true)
  double? volumeLevel;

  @Column(nullable: true)
  String? pagesChangeEffect;

  @Column(nullable: true)
  String? dialoguesWindowType;

  @Column(nullable: true)
  bool? staticText;

  @Column(nullable: true)
  double? textGrowthSpeed;

  @Relate(#settings)
  User? user;

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
