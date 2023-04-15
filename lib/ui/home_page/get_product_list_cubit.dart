import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data_class/product.dart';
import '../../network/ProductRepository.dart';

part 'get_product_list_state.dart';

class GetProductListCubit extends Cubit<GetProductListState> {
  final ProductRepository productRepository;

  GetProductListCubit(this.productRepository) : super(GetProductLoading()) {
    getProductList();
  }

  Future<void> getProductList() async {
    try {
      emit(GetProductLoading());
      final productList = await productRepository.getProductList();
      emit(GetProductSuccess(productList));
    } catch (e) {
      emit(GetProductError(e.toString()));
    }
  }

  void success(List<Product> productList) =>
      emit(GetProductSuccess(productList));

  void error(String error) => emit(GetProductError(error));
}
