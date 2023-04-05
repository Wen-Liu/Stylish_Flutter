import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stylish/extensions.dart';
import '../../data_class/product.dart';

class DetailViewModel extends ChangeNotifier {
  late Product _product;
  final _currentColor = ValueNotifier<ProductColor?>(null);
  final _currentSize = ValueNotifier<String?>(null);
  final _currentStock = ValueNotifier<int>(0);
  final _currentQuantity = ValueNotifier<int>(0);

  Product get product => _product;

  ValueListenable<ProductColor?> get currentColor => _currentColor;

  ValueListenable<String?> get currentSize => _currentSize;

  ValueListenable<int> get currentStock => _currentStock;

  ValueListenable<int> get currentQuantity => _currentQuantity;

  void setProduct(Product product) {
    _product = product;
  }

  void setColor(ProductColor color) {
    print("setColor = ${currentColor.value?.name} -> ${color.name}");
    _currentColor.value = color;

    checkStock();
  }

  void setSize(String size) {
    print("setSize = ${currentSize.value} -> $size");
    _currentSize.value = size;

    checkStock();
  }

  void checkStock() {
    Variant? variant = product.variants.firstWhereOrNull((element) =>
        element.size == currentSize.value &&
        element.colorCode == currentColor.value?.code);

    if (variant != null && _currentStock.value != variant.stock) {
      _currentStock.value = variant.stock;
      print("currentStock= ${_currentStock.value} ");
      notifyListeners();
    }
  }

  void changeQuantity(int changeValue) {
    _currentQuantity.value += changeValue;
  }
}
