import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration2 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("favorites", SchemaColumn("product_id", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("cart_products", SchemaColumn("productId", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    