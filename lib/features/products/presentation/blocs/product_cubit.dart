import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/product_repository.dart';
import '../../models/product_model.dart';


part 'product_state.dart';


class ProductCubit extends Cubit<ProductState> {
final ProductRepository repository;
ProductCubit({required this.repository}) : super(ProductState.initial());


Future<void> fetchProducts() async {
emit(state.copyWith(status: ProductStatus.loading));
try {
final products = await repository.fetchProducts();
emit(state.copyWith(status: ProductStatus.success, products: products));
} catch (e) {
emit(state.copyWith(status: ProductStatus.failure, errorMessage: e.toString()));
}
}


Future<void> addProduct(Product product) async {
final list = List<Product>.from(state.products);
emit(state.copyWith(status: ProductStatus.loading));
try {
final newProduct = await repository.addProduct(product);
list.add(newProduct);
emit(state.copyWith(status: ProductStatus.success, products: list));
} catch (e) {
emit(state.copyWith(status: ProductStatus.failure, errorMessage: e.toString()));
}
}


Future<void> updateProduct(Product product) async {
emit(state.copyWith(status: ProductStatus.loading));
try {
final updated = await repository.updateProduct(product);
final list = state.products.map((p) => p.id == updated.id ? updated : p).toList();
emit(state.copyWith(status: ProductStatus.success, products: list));
} catch (e) {
emit(state.copyWith(status: ProductStatus.failure, errorMessage: e.toString()));
}
}


Future<void> deleteProduct(String id) async {
emit(state.copyWith(status: ProductStatus.loading));
try {
await repository.deleteProduct(id);
final list = state.products.where((p) => p.id != id).toList();
emit(state.copyWith(status: ProductStatus.success, products: list));
} catch (e) {
emit(state.copyWith(status: ProductStatus.failure, errorMessage: e.toString()));
}
}
}