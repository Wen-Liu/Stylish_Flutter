abstract class BaseApiServices {
  // Get Request
  Future<dynamic> callGetApiResponse({
    required String endpoint,
    Map<String, dynamic>? parameters,
  });

  // Post Request
  Future<dynamic> callPostApiResponse({
    required String endpoint,
    required dynamic body,
    Map<String, dynamic>? parameters,
  });

  // Put Request
  Future<dynamic> callPutApiResponse({
    required String endpoint,
    required dynamic body,
    Map<String, dynamic>? parameters,
  });

  // Delete Request
  Future<dynamic> callDeleteApiResponse({
    required String endpoint,
    required dynamic body,
    Map<String, dynamic>? parameters,
  });
}
