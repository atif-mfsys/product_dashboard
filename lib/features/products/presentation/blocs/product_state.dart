part of 'product_cubit.dart';


enum ProductStatus { initial, loading, success, failure }


class ProductState extends Equatable {
final ProductStatus status;
final List<Product> products;
final String? errorMessage;


ProductState({required this.status, required this.products, this.errorMessage});


factory ProductState.initial() => ProductState(status: ProductStatus.initial, products: []);


ProductState copyWith({ProductStatus? status, List<Product>? products, String? errorMessage}) {
return ProductState(status: status ?? this.status, products: products ?? this.products, errorMessage: errorMessage ?? this.errorMessage);
}


@override
List<Object?> get props => [status, products, errorMessage];
}