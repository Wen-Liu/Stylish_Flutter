class ProductResponse {
  final List<Product> data;
  int? nextPage;

  ProductResponse({
    required this.data,
    this.nextPage,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    List<Product> productList = [];

    for (dynamic data in json['data']) {
      productList.add(Product.fromJson(data));
    }

    return ProductResponse(
      data: productList,
      nextPage: json['next_paging'],
    );
  }
}

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
  final List<ProductColor> colors;
  final List<String> sizes;
  final List<Variant> variants;
  final String mainImage;
  final List<String> images;

  Product({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.price,
    required this.texture,
    required this.wash,
    required this.place,
    required this.note,
    required this.story,
    required this.mainImage,
    required this.images,
    required this.variants,
    required this.colors,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> imagesList = [];
    List<Variant> variantsList = [];
    List<ProductColor> colorsList = [];
    List<String> sizesList = [];

    for (String image in json['images']) {
      imagesList.add(image);
    }

    for (dynamic variant in json['variants']) {
      variantsList.add(Variant.fromJson(variant));
    }

    for (dynamic color in json['colors']) {
      colorsList.add(ProductColor.fromJson(color));
    }

    for (String size in json['sizes']) {
      sizesList.add(size);
    }
    return Product(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      texture: json['texture'],
      wash: json['wash'],
      place: json['place'],
      note: json['note'],
      story: json['story'],
      mainImage: json['main_image'],
      images: imagesList,
      variants: variantsList,
      colors: colorsList,
      sizes: sizesList,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, category: $category, \ncolors: $colors, \nsizes: $sizes, \nvariants: $variants}';
  }
}

class ProductColor {
  final String code;
  final String name;

  ProductColor({required this.code, required this.name});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      code: json['code'],
      name: json['name'],
    );
  }

  @override
  String toString() {
    return 'ProductColor{code: $code, name: $name}';
  }
}

class Variant {
  final String colorCode;
  final String size;
  final int stock;

  Variant({required this.colorCode, required this.size, required this.stock});

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      colorCode: json['color_code'],
      size: json['size'],
      stock: json['stock'],
    );
  }

  @override
  String toString() {
    return '\nVariant{colorCode: $colorCode, size: $size, stock: $stock} ';
  }
}

class ApiResponse {
  List<Product> data;
  int nextPaging;

  ApiResponse({
    required this.data,
    required this.nextPaging,
  });
}
