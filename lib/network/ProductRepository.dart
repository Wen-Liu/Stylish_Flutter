import 'dart:convert';

import 'package:stylish/data_class/get_campaign_response.dart';
import 'package:stylish/network/api_service.dart';

import '../data_class/get_product_response.dart';

class ProductRepository {
  ProductRepository({
    ApiService? apiService,
  }) : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<Product>> getProductData() async {
    List<Product> list = [];
    int? page = 0;

    while (page != null) {
      final response = await _apiService.getAllProduct(page.toString());
      if (response.statusCode == 200) {
        final responseData = ProductResponse.fromJson(response.data);
        list.addAll(responseData.data);
        page = responseData.nextPage;
      } else {
        throw Exception(response.statusCode);
      }
    }

    return list;
  }

  Future<List<Product>> getHotData() async {
    final response = await _apiService.getHotData();
    print("getHotData= $response");
    if (response.statusCode == 200) {
      final responseData = ProductResponse.fromJson(response.data);
      return responseData.data;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<Campaign>> getCampaignData() async {
    final response = await _apiService.getCampaignData();
    print("getCampaignData= $response");
    if (response.statusCode == 200) {
      final responseData = CampaignResponse.fromJson(response.data);
      return responseData.campaignList;
    } else {
      throw Exception(response.statusCode);
    }
  }
}

List<dynamic> parseProductData(List<Product> data, {String type = "all"}) {
  List<dynamic> list = [];

  if (type == "all") {
    list.add("女裝");
    list.addAll(data.where((element) => element.category == "women"));
    list.add("男裝");
    list.addAll(data.where((element) => element.category == "men"));
    list.add("配件");
    list.addAll(data.where((element) => element.category == "accessories"));
  } else {
    list.addAll(data.where((element) => element.category == type));
  }

  return list;
}

Map<String, dynamic> getJsonMap() {
  return {
    "id": 201807201824,
    "category": "women",
    "title": "UNIQLO 特級輕羽絨外套",
    "description": "厚薄：薄\r\n彈性：無",
    "price": 799,
    "texture": "棉 100%",
    "wash": "手洗，溫水",
    "place": "中國",
    "note": "實品顏色依單品照為主",
    "story":
        "O.N.S is all about options, which is why we took our staple polo shirt and upgraded it with slubby linen jersey, making it even lighter for those who prefer their summer style extra-breezy.",
    "main_image": "https://api.appworks-school.tw/assets/201807201824/main.jpg",
    "images": [
      "https://api.appworks-school.tw/assets/201807201824/0.jpg",
      "https://api.appworks-school.tw/assets/201807201824/1.jpg",
      "https://api.appworks-school.tw/assets/201807201824/0.jpg",
      "https://api.appworks-school.tw/assets/201807201824/1.jpg"
    ],
    "variants": [
      {"color_code": "334455", "size": "S", "stock": 5},
      {"color_code": "334455", "size": "M", "stock": 10},
      {"color_code": "FFFFFF", "size": "S", "stock": 0},
      {"color_code": "FFFFFF", "size": "M", "stock": 2},
      {"color_code": "FFFFFF", "size": "L", "stock": 2}
    ],
    "colors": [
      {"code": "FFFFFF", "name": "白色"},
      {"code": "FFDDDD", "name": "粉紅"},
      {"code": "334455", "name": "深藍"}
    ],
    "sizes": ["S", "M", "L"]
  };
}
