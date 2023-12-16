// ignore_for_file: unused_element

import 'package:conduit_core/conduit_core.dart';
import 'package:ecom_backend/data/model/cart_product.dart';
import 'package:ecom_backend/data/model/user.dart';

class Cart extends ManagedObject<_Cart> implements _Cart {}

@Table(name: 'carts')
class _Cart {
  _Cart({
    this.id = 0,
    this.price = '',
    this.products,
    this.user,
  });
  @Column(autoincrement: true, primaryKey: true)
  final int id;

  String price;

  ManagedSet<CartProduct>? products;

  @Relate(#cart)
  User? user;
}
