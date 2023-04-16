import 'package:bloc/bloc.dart';
import 'package:stylish/data_class/get_campaign_response.dart';
import 'package:stylish/data_class/get_product_response.dart';
import 'package:stylish/ui/home_page/get_product_list_cubit.dart';

import '../../network/ProductRepository.dart';

class GetCampaignCubit extends Cubit<ApiState> {
  final ProductRepository productRepository;

  GetCampaignCubit(this.productRepository) : super(Loading()) {
    getCampaignData();
  }

  Future<void> getCampaignData() async {
    try {
      emit(Loading());
      final dataList = await productRepository.getCampaignData();
      emit(ApiSuccess<List<Campaign>>(dataList));
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }

  void success(List<Product> productList) => emit(ApiSuccess(productList));

  void error(String error) => emit(ApiError(error));
}
