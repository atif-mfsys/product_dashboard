import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_cubit.dart';
import '../widgets/product_form.dart';


class ProductDetailsPage extends StatelessWidget {
final String productId;
const ProductDetailsPage({required this.productId});


@override
Widget build(BuildContext context) {
final cubit = context.read<ProductCubit>();
final product = cubit.state.products.firstWhere((p) => p.id == productId, orElse: () => throw Exception('Not found'));


return Scaffold(
appBar: AppBar(title: Text(product.name)),
body: Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Category: ${product.category}'),
SizedBox(height: 8),
Text('Price: \$${product.price.toStringAsFixed(2)}'),
SizedBox(height: 8),
Text('Availability: ${product.inStock ? 'In stock' : 'Out of stock'}'),
SizedBox(height: 24),
ElevatedButton.icon(onPressed: () => showDialog(context: context, builder: (_) => BlocProvider.value(value: cubit, child: ProductFormModal(editProduct: product))), icon: Icon(Icons.edit), label: Text('Edit')),
],
),
),
);
}
}