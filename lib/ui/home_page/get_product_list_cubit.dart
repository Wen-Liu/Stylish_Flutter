import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data_class/get_all_product_response.dart';
import '../../network/product_repository.dart';

part '../../network/api_state.dart';

class GetProductListCubit extends Cubit<ApiState> {
  final ProductRepository productRepository;

  GetProductListCubit(this.productRepository) : super(Loading()) {
    getProductList();
  }

  Future<void> getProductList() async {
    try {
      emit(Loading());
      final productList = await productRepository.getAllProductData();
      emit(ApiSuccess<List<Product>>(productList));
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }

  void success(List<Product> productList) =>
      emit(ApiSuccess(productList));

  void error(String error) => emit(ApiError(error));
}
