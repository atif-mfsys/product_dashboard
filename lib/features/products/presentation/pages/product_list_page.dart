import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_product_dashboard/features/products/presentation/widgets/sideBar.dart';
import '../../models/product_model.dart';
import '../blocs/product_cubit.dart';
import '../widgets/product_table.dart';
import '../widgets/product_form.dart';


class ProductListPage extends StatefulWidget {
@override
_ProductListPageState createState() => _ProductListPageState();
}


class _ProductListPageState extends State<ProductListPage> {
String _filterCategory = 'All';
String _search = '';


void _openAdd() {
showDialog(context: context, builder: (_) => BlocProvider.value(value: context.read<ProductCubit>(), child: ProductFormModal()));
}


@override
Widget build(BuildContext context) {
return Scaffold(
body: Row(
children: [
Sidebar(),
Expanded(
child: SafeArea(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
_buildTopBar(),
SizedBox(height: 16),
Expanded(child: _buildBody()),
],
),
),
),
),
],
),
floatingActionButton: FloatingActionButton.extended(onPressed: _openAdd, label: Text('Add Product'), icon: Icon(Icons.add)),
);
}


Widget _buildTopBar() {
return Row(
children: [
Expanded(child: Text('Products', style: Theme.of(context).textTheme.headlineLarge)),
SizedBox(width: 16),
Container(width: 300, child: TextField(onChanged: (v) => setState(() => _search = v), decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search product name'))),
SizedBox(width: 16),
DropdownButton<String>(value: _filterCategory, items: ['All', 'Electronics', 'Accessories', 'Furniture'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _filterCategory = v ?? 'All')),
],
);
}


Widget _buildBody() {
return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
if (state.status == ProductStatus.loading) return Center(child: CircularProgressIndicator());
if (state.products.isEmpty) return Center(child: Text('No products'));


final filtered = state.products.where((p) {
final matchesCategory = _filterCategory == 'All' || p.category == _filterCategory;
final matchesSearch = p.name.toLowerCase().contains(_search.toLowerCase());
return matchesCategory && matchesSearch;
}).toList();


return ProductTable(products: filtered);
});
}
}