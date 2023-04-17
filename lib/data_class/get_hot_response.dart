import 'package:stylish/data_class/get_all_product_response.dart';

class HotResponse {
  final List<Product> data;
  String? title;

  HotResponse({
    required this.data,
    this.title,
  });

  factory HotResponse.fromJson(Map<String, dynamic> json) {
    List<Product> productList = [];

    for (dynamic product in json['data']) {
      productList.add(Product.fromJson(product));
    }

    return HotResponse(
      data: productList,
      title: json['title'],
    );
  }
}