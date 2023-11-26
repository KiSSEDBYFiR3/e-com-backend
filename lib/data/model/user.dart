import 'package:conduit_core/conduit_core.dart';

class User extends ManagedObject<_User> implements _User {}

@Table(name: 'users', useSnakeCaseColumnName: true)
class _User {
  _User({
    this.email = '',
    this.name = '',
    this.id = 0,
    this.refreshToken = '',
    this.userId = '',
  });

  @Column(primaryKey: true, autoincrement: true)
  int? id;
  @Column()
  String? userId;
  @Column()
  String? email;
  @Column()
  String? name;
  @Column()
  String? refreshToken;
}
