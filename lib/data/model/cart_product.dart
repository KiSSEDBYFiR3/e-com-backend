// ignore_for_file: unused_element

import 'package:conduit_core/conduit_core.dart';
import 'package:ecom_backend/data/model/cart.dart';

class CartProduct extends ManagedObject<_CartProduct> implements _CartProduct {}

@Table(name: 'cart_products')
class _CartProduct {
  _CartProduct({
    this.id = 0,
    this.cart,
    this.category,
    this.description,
    this.image,
    this.price,
    this.title,
    this.productId,
  });
  @Column(autoincrement: true, primaryKey: true)
  int? id;

  @Column(name: 'product_id')
  int? productId;

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

  @Relate(#products)
  Cart? cart;
}
