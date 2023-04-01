import 'data_class/product.dart';

List<dynamic> getProductListData(String? title, int listSize) {
  final data = Product.fromJson(getJsonMap());
  return [
    if (title != null) title,
    ...List.generate(listSize, (_) => data)
  ];
}

List<dynamic> getAllProductListData() {
  List<dynamic> list = [];
  list.addAll(getProductListData("女裝", 3));
  list.addAll(getProductListData("男裝", 5));
  list.addAll(getProductListData("配件", 10));
  return list;
}

List<String> getBannerList() {
  return List<String>.filled(10, "assets/images/banner_photo.jpeg");
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
