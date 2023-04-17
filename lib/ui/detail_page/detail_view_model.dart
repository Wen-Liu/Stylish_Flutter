import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/data_class/get_all_product_response.dart';
import 'package:stylish/extensions.dart';
import 'package:stylish/ui/home_page/get_product_list_cubit.dart';

import '../../network/ProductRepository.dart';

class StockCubit extends Cubit<StockData> {
  StockCubit(Product product) : super(StockData(product: product)) {
    // print("\nproduct= ${product.toString()}\n");
  }

  void increment() => emit(state.copyWith(quantityChange: 1));

  void decrement() => emit(state.copyWith(quantityChange: -1));

  void setSize(String size) => emit(state.copyWith(size: size));

  void setColor(String color) => emit(state.copyWith(color: color));
}

class StockData {
  StockData(
      {required this.product,
      this.size = "Default",
      this.color = "Default",
      this.quantity = 0,
      this.stock = 0});

  final Product product;
  final String size;
  final String color;
  final int quantity;
  final int stock;

  StockData copyWith({String? size, String? color, int quantityChange = 0}) {
    int stock = this.stock;
    String finalSize = size ?? this.size;
    String finalColor = color ?? this.color;
    int finalQuantity = quantity + quantityChange;

    if (size != null || color != null) {
      Variant? variant = product.variants.firstWhereOrNull((element) =>
          element.size == finalSize && element.colorCode == finalColor);

      if (variant != null) stock = variant.stock;

      if (finalQuantity > stock) finalQuantity = stock;

      if (finalQuantity == 0 && stock > 0) finalQuantity = 1;
    }
    print(
        "fColor= $finalColor, fSize= $finalSize, fQuantity= $finalQuantity, stock=$stock");
    return StockData(
        product: product,
        size: finalSize,
        color: finalColor,
        quantity: finalQuantity,
        stock: stock);
  }
}

class DetailCubit extends Cubit<ApiState> {
  final ProductRepository repo;
  final int id;
  Product? product;

  DetailCubit({
    required this.repo,
    required this.id,
    this.product,
  }) : super(Loading()) {
    if (product != null) {
      emit(ApiSuccess<Product>(product!));
    } else {
      getProduct(id: id);
    }
  }

  Future<void> getProduct({required int id}) async {
    try {
      product = await repo.getSingleProductData(id);
      emit(ApiSuccess<Product>(product!));
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }
}
