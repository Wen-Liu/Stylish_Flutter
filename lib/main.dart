import 'dart:html';

import 'package:flutter/material.dart';
import 'Product.dart';

void main() {
  runApp(const MyApp());
}

List<Product> getWomenList() {
  return List<Product>.filled(
      3,
      Product(
          title: "UNIQLO 特級極輕羽絨外套",
          mainImage: 'images/item_image.jpeg',
          price: 323));
}

List<Product> getMenList() {
  return List<Product>.filled(
      5,
      Product(
          title: "UNIQLO 特級極輕羽絨外套",
          mainImage: 'images/item_image.jpeg',
          price: 323));
}

List<Product> getAccessoryList() {
  return List<Product>.filled(
      8,
      Product(
          title: "UNIQLO 特級極輕羽絨外套",
          mainImage: 'images/item_image.jpeg',
          price: 323));
}

List<String> getBannerList() {
  return List<String>.filled(10, "images/banner_photo.jpeg");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
            'images/stylish_app_bar.png',
            fit: BoxFit.contain,
            height: AppBar().preferredSize.height / 3,
          ),
        ),
        body: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: CustomListView(bannerList: getBannerList()),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomVerticalListView(
                      title: "女裝", productList: getWomenList()),
                  CustomVerticalListView(
                      title: "男裝", productList: getMenList()),
                  CustomVerticalListView(
                      title: "配件", productList: getAccessoryList())
                ],
              ),
            )
          ],
        ));
  }
}

class CustomListView extends StatelessWidget {
  const CustomListView({super.key, required this.bannerList});

  final List<String> bannerList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child:
                  Image.asset(bannerList[index], width: 200, fit: BoxFit.fill));
        });
    // ,
    // );
  }
}

class CustomVerticalListView extends StatelessWidget {
  const CustomVerticalListView(
      {super.key, required this.title, required this.productList});

  final String title;
  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: productList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold)));
              default:
                return Item(product: productList[index - 1]);
            }
          }),
    );
  }
}

class Item extends StatelessWidget {
  const Item({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: theme.colorScheme.primary,
      elevation: 5.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            product.mainImage,
            width: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title),
                Text("NT\$${product.price}")
              ],
            ),
          )
        ],
      ),
    );
  }
}
