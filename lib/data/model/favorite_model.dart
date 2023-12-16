// ignore_for_file: unused_element

import 'package:ecom_backend/data/model/user.dart';
import 'package:ecom_backend/ecom_backend.dart';

class FavoriteProduct extends ManagedObject<_FavoriteProduct>
    implements _FavoriteProduct {}

@Table(name: 'favorites', useSnakeCaseColumnName: true)
class _FavoriteProduct {
  _FavoriteProduct({
    this.id = 0,
    this.category,
    this.description,
    this.image,
    this.price,
    this.title,
    this.user,
  });
  @Column(primaryKey: true, autoincrement: true)
  int? id;

  @Column()
  String? image;

  @Column()
  String? description;

  @Column()
  String? title;

  @Column()
  String? price;

  @Column()
  String? category;

  @Relate(#favorites)
  User? user;
}
