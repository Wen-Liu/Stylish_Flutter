import 'package:dio/dio.dart';

class ApiService {
  static const _baseEndpoint = "https://api.appworks-school.tw/api/1.0";
  static const _marketingCampaigns = "/marketing/campaigns";
  static const _marketingHots = "/marketing/hots";

  static const _productAll = "/products/all";
  static const _productWomen = "/products/women";
  static const _productMen = "/products/men";
  static const _productAccessories = "/products/accessories";
  static const _productDetails = "/products/details";

  static const _userSignUp = "/user/signup";
  static const _userSignIn = "/user/signin";
  static const _userProfile = "/user/profile";

  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseEndpoint,
    ));
  }

  Future<Response> getAllProduct(String page) async {
    return await callGetApiResponse(
        endpoint: _productAll, parameters: {"paging": page});
  }

  Future<Response> getHotData() async {
    return await callGetApiResponse(endpoint: _marketingHots);
  }

  Future<Response> getCampaignData() async {
    return await callGetApiResponse(endpoint: _marketingCampaigns);
  }

  Future<Response> callGetApiResponse(
      {required String endpoint, Map<String, dynamic>? parameters}) async {
    Response response;
    response = await _dio.get(endpoint, queryParameters: parameters);
    return response;
  }

  Future callPostApiResponse({
    required String endpoint,
    required body,
    Map<String, dynamic>? parameters,
  }) {
    throw UnimplementedError();
  }

  Future callPutApiResponse({
    required String endpoint,
    required body,
    Map<String, dynamic>? parameters,
  }) {
    // TODO: implement callPutApiResponse
    throw UnimplementedError();
  }

  Future callDeleteApiResponse({
    required String endpoint,
    required body,
    Map<String, dynamic>? parameters,
  }) {
    // TODO: implement callDeleteApiResponse
    throw UnimplementedError();
  }
}
