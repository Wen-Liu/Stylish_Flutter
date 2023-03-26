import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data_class/product.dart';
import '../repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 242, 244, 246),
            title: Image.asset(
              'assets/images/stylish_app_bar.png',
              fit: BoxFit.contain,
              height: AppBar().preferredSize.height / 2,
            ),
            centerTitle: true,
            elevation: 1),
        body: Flex(
          direction: Axis.vertical,
          children: [
            BannerView(bannerList: getBannerList()),
            Expanded(
                flex: 1,
                child: LayoutBuilder(builder: (context, constraints) {
                  if (kDebugMode) {
                    print("maxWidth=${constraints.maxWidth}");
                  }
                  if (constraints.maxWidth > 600) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductListView(
                            productList: getProductListData(
                                "女裝", 3, "assets/images/women_image.png")),
                        ProductListView(
                            productList: getProductListData(
                                "男裝", 5, "assets/images/men_image.jpeg")),
                        ProductListView(
                            productList: getProductListData(
                                "配件", 10, "assets/images/women_image.png"))
                      ],
                    );
                  } else {
                    return ProductListView(
                        productList: getAllProductListData());
                  }
                }))
          ],
        ));
  }
}

class BannerView extends StatelessWidget {
  const BannerView({super.key, required this.bannerList});

  final List<String> bannerList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(bannerList[index],
                      width: 200, fit: BoxFit.fill));
            }));
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({super.key, required this.productList});

  final List<dynamic> productList;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: productList.length,
          itemBuilder: (BuildContext context, int index) {
            if (productList[index] is Product) {
              return ItemView(product: productList[index]);
            } else if (productList[index] is String) {
              return ProductTitleView(title: productList[index]);
            }
            return null;
          }),
    );
  }
}

class ProductTitleView extends StatelessWidget {
  const ProductTitleView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold)));
  }
}

class ItemView extends StatelessWidget {
  const ItemView({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Colors.black,
              width: 1.0,
            )),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Image.asset(
              product.mainImage,
              width: 80,
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title),
                      Text("NT\$ ${product.price}")
                    ],
                  ),
                ))
          ],
        ));
  }
}
