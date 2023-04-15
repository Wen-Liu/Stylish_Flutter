part of 'get_product_list_cubit.dart';

@immutable
abstract class GetProductListState {}

class GetProductLoading extends GetProductListState {}

class GetProductSuccess extends GetProductListState {
  final List<Product> productList;

  GetProductSuccess(this.productList);
}

class GetProductError extends GetProductListState {
  final String errorCode;

  GetProductError(this.errorCode);
}
