import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'dart:html' as html; // web localStorage
import '../models/product_model.dart';


class ProductRepository {
final _storageKey = 'product_dashboard_products_v1';
final Uuid _uuid = Uuid();


Future<List<Product>> fetchProducts() async {
// check localStorage first
final saved = html.window.localStorage[_storageKey];
if (saved != null) {
final list = (json.decode(saved) as List).map((e) => Product.fromMap(e)).toList();
return list;
}


// fallback to assets JSON
final raw = await rootBundle.loadString('assets/products.json');
final list = (json.decode(raw) as List).map((e) => Product.fromMap(e)).toList();
await _save(list);
return list;
}


Future<void> _save(List<Product> products) async {
html.window.localStorage[_storageKey] = json.encode(products.map((p) => p.toMap()).toList());
}


Future<Product> addProduct(Product product) async {
final list = await fetchProducts();
final newProduct = product.copyWith(id: product.id.isNotEmpty ? product.id : _uuid.v4());
list.add(newProduct);
await _save(list);
return newProduct;
}


Future<Product> updateProduct(Product product) async {
final list = await fetchProducts();
final index = list.indexWhere((p) => p.id == product.id);
if (index == -1) throw Exception('Product not found');
list[index] = product;
await _save(list);
return product;
}


Future<void> deleteProduct(String id) async {
final list = await fetchProducts();
list.removeWhere((p) => p.id == id);
await _save(list);
}
}