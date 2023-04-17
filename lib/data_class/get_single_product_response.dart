import 'get_all_product_response.dart';

class SingleProductResponse {
  final Product data;

  SingleProductResponse({required this.data});

  factory SingleProductResponse.fromJson(Map<String, dynamic> json) {
    return SingleProductResponse(data: Product.fromJson(json["data"]));
  }
}
