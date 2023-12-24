// ignore_for_file: unused_element

import 'package:conduit_core/conduit_core.dart';
import 'package:ecom_backend/data/model/cart.dart';
import 'package:ecom_backend/data/model/favorite_model.dart';

class User extends ManagedObject<_User> implements _User {}

@Table(name: 'users', useSnakeCaseColumnName: true)
class _User {
  _User({
    this.id,
    this.refreshToken,
    this.favorites,
    this.cart,
  });

  @Column(primaryKey: true, autoincrement: true)
  int? id;
  @Column(nullable: true)
  String? userId;
  @Column()
  String? refreshToken;

  ManagedSet<FavoriteProduct>? favorites;
  Cart? cart;
}
