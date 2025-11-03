import 'package:flutter/material.dart';
import 'package:flutter_product_dashboard/features/products/presentation/widgets/product_form.dart';
import 'package:go_router/go_router.dart';
import '../../models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_cubit.dart';

class ProductTable extends StatelessWidget {
  final List<Product> products;
  ProductTable({required this.products});

  @override
  Widget build(BuildContext context) {
// Responsive: show DataTable on wide screens, GridView on narrow
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 900) {
        return SingleChildScrollView(
            child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Actions'))
          ],
          rows: products
              .map<DataRow>((p) => DataRow(cells: [
                    DataCell(Text(p.id)),
                    DataCell(
                      InkWell(
                        onTap: () => context.go('/product/${p.id}'),
                        child: Text(p.name),
                      ),
                    ),
                    DataCell(Text(p.category)),
                    DataCell(Text('\$${p.price.toStringAsFixed(2)}')),
                    DataCell(Text(p.inStock ? 'In stock' : 'Out of stock')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                value: context.read<ProductCubit>(),
                                child: ProductFormModal(editProduct: p),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => context
                                .read<ProductCubit>()
                                .deleteProduct(p.id),
                          ),
                        ],
                      ),
                    ),
                  ]))
              .toList(),
        ));
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
            childAspectRatio: 4),
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return Card(
            child: ListTile(
              title: Text(p.name),
              subtitle: Text('${p.category} • \$${p.price.toStringAsFixed(2)}'),
              trailing: PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit')
                      showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                              value: context.read<ProductCubit>(),
                              child: ProductFormModal(editProduct: p)));
                    if (v == 'delete')
                      context.read<ProductCubit>().deleteProduct(p.id);
                  },
                  itemBuilder: (_) => [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete'))
                      ]),
              onTap: () => context.go('/product/${p.id}'),
            ),
          );
        },
      );
    });
  }
}
