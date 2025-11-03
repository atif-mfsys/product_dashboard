import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_product_dashboard/features/products/data/product_repository.dart';
import 'package:flutter_product_dashboard/features/products/presentation/blocs/product_cubit.dart';
import 'package:flutter_product_dashboard/features/products/presentation/pages/product_details_page.dart';
import 'package:flutter_product_dashboard/features/products/presentation/pages/product_list_page.dart';
import 'package:go_router/go_router.dart';



void main() async {
WidgetsFlutterBinding.ensureInitialized();
final repository = ProductRepository();
runApp(MyApp(repository: repository));
}


class MyApp extends StatelessWidget {
final ProductRepository repository;
MyApp({required this.repository});


@override
Widget build(BuildContext context) {
final _router = GoRouter(
initialLocation: '/',
routes: [
GoRoute(path: '/', builder: (context, state) => ProductListPage()),
GoRoute(path: '/product/:id', builder: (context, state) {
final id = state.params['id']!;
return ProductDetailsPage(productId: id);
}),
],
);


return RepositoryProvider.value(
value: repository,
child: BlocProvider(
create: (_) => ProductCubit(repository: repository)..fetchProducts(),
child: MaterialApp.router(
debugShowCheckedModeBanner: false,
title: 'Product Dashboard',
theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
routerConfig: _router,
),
),
);
}
}