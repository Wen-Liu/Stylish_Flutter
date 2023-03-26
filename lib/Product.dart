class Product {
  final int id;
  final String category;
  final String title;
  final String description;
  final int price;
  final String texture;
  final String wash;
  final String place;
  final String note;
  final String story;
  final List<ProductColor>? colors;
  final List<String>? sizes;
  final List<Variant>? variants;
  final String mainImage;
  final List<String>? images;

  Product({
    this.id = 0,
    this.category = "",
    required this.title,
    this.description = "",
    required this.price,
    this.texture = "",
    this.wash = "",
    this.place = "",
    this.note = "",
    this.story = "",
    this.colors,
    this.sizes,
    this.variants,
    required this.mainImage,
    this.images,
  });
}

class ProductColor {
  final String code;
  final String name;

  ProductColor({required this.code, required this.name});
}

class Variant {
  final String colorCode;
  final String size;
  final int stock;

  Variant({required this.colorCode, required this.size, required this.stock});
}

class ApiResponse {
  List<Product> data;
  int nextPaging;

  ApiResponse({
    required this.data,
    required this.nextPaging,
  });
}
