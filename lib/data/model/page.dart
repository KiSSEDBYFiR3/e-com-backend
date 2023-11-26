import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/soc_backend.dart';

part 'page.g.dart';

class Page extends ManagedObject<_Page> implements _Page {}

@JsonSerializable(
  createToJson: true,
  createFactory: true,
  fieldRename: FieldRename.snake,
)
@Table(name: 'pages', useSnakeCaseColumnName: true)
class _Page {
  const _Page({
    this.id = 0,
    this.currentCharacter = '',
    this.scenaryImage = '',
    this.scenaryTransitionEffect = '',
    this.animationEffect = '',
    this.characterImage = '',
    this.currentDialoguePhrase = '',
    this.endOfScenary = false,
    this.batchId = '',
    this.soundTrack = '',
    this.nextBatch = '',
  });

  @Column(
    primaryKey: true,
  )
  final int id;

  @Column()
  final String batchId;

  @Column()
  final String? currentCharacter;

  @Column()
  final String currentDialoguePhrase;

  @Column(nullable: true)
  final String? characterImage;

  @Column()
  final String scenaryImage;

  @Column(nullable: true)
  final String? scenaryTransitionEffect;

  @Column(nullable: true)
  final String? animationEffect;

  @Column(nullable: true)
  final bool? endOfScenary;

  @Column()
  final String nextBatch;

  @Column(nullable: true)
  final String soundTrack;

  Map<String, dynamic> toJson() => _$PageToJson(this);
  factory _Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
