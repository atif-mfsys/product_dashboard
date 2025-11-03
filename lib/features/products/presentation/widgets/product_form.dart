import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product_model.dart';
import '../blocs/product_cubit.dart';

class ProductFormModal extends StatefulWidget {
  final Product? editProduct;
  ProductFormModal({this.editProduct});

  @override
  _ProductFormModalState createState() => _ProductFormModalState();
}

class _ProductFormModalState extends State<ProductFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _priceC;
  String _category = 'Electronics';
  bool _inStock = true;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.editProduct?.name ?? '');
    _priceC =
        TextEditingController(text: widget.editProduct?.price.toString() ?? '');
    _category = widget.editProduct?.category ?? 'Electronics';
    _inStock = widget.editProduct?.inStock ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    widget.editProduct == null ? 'Add Product' : 'Edit Product',
                    style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 12),
                TextFormField(
                    controller: _nameC,
                    decoration: InputDecoration(labelText: 'Product name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null),
                SizedBox(height: 8),
                TextFormField(
                    controller: _priceC,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: 'Price'),
                    validator: (v) => (v == null || double.tryParse(v) == null)
                        ? 'Enter valid price'
                        : null),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                    value: _category,
                    items: ['Electronics', 'Accessories', 'Furniture']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _category = v ?? _category),
                    decoration: InputDecoration(labelText: 'Category')),
                SizedBox(height: 8),
                SwitchListTile(
                    title: Text('In stock'),
                    value: _inStock,
                    onChanged: (v) => setState(() => _inStock = v)),
                SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel')),
                  SizedBox(width: 8),
                  ElevatedButton(onPressed: _submit, child: Text('Save'))
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameC.text.trim();
    final price = double.parse(_priceC.text.trim());

    final cubit = context.read<ProductCubit>();

    if (widget.editProduct == null) {
      final newP = Product(
          id: '',
          name: name,
          category: _category,
          price: price,
          inStock: _inStock);
      await cubit.addProduct(newP);
    }
  }
}
