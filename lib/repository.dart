import 'data_class/product.dart';

List<dynamic> getProductListData(
    String? title, int listSize, String imagePath) {
  List<dynamic> list = [];
  if (title != null) {
    list.add(title);
  }
  list.addAll(List<Product>.filled(listSize,
      Product(title: "UNIQLO 特級極輕羽絨外套", mainImage: imagePath, price: 323)));
  return list;
}

List<dynamic> getAllProductListData() {
  List<dynamic> list = [];
  list.addAll(getProductListData("女裝", 3, "assets/images/women_image.png"));
  list.addAll(getProductListData("男裝", 5, "assets/images/men_image.jpeg"));
  list.addAll(
      getProductListData("配件", 10, "assets/images/accessory_image.jpeg"));
  return list;
}

List<String> getBannerList() {
  return List<String>.filled(10, "assets/images/banner_photo.jpeg");
}
