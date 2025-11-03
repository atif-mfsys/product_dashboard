import 'dart:convert';


class Product {
final String id;
final String name;
final String category;
final double price;
final bool inStock;


Product({required this.id, required this.name, required this.category, required this.price, required this.inStock});


Product copyWith({String? id, String? name, String? category, double? price, bool? inStock}) {
return Product(
id: id ?? this.id,
name: name ?? this.name,
category: category ?? this.category,
price: price ?? this.price,
inStock: inStock ?? this.inStock,
);
}


factory Product.fromMap(Map<String, dynamic> map) {
return Product(
id: map['id'].toString(),
name: map['name'] ?? '',
category: map['category'] ?? 'Uncategorized',
price: (map['price'] is int) ? (map['price'] as int).toDouble() : (map['price'] as num).toDouble(),
inStock: map['inStock'] == true,
);
}


Map<String, dynamic> toMap() {
return {'id': id, 'name': name, 'category': category, 'price': price, 'inStock': inStock};
}


String toJson() => json.encode(toMap());
factory Product.fromJson(String source) => Product.fromMap(json.decode(source));
}