import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/data_class/get_campaign_response.dart';
import 'package:stylish/extensions.dart';
import 'package:stylish/ui/detail_page/detail_page.dart';
import 'package:stylish/ui/home_page/get_campaign_cubit.dart';
import 'package:stylish/ui/home_page/get_product_list_cubit.dart';
import '../../data_class/get_product_response.dart';
import '../../network/ProductRepository.dart';
import '../stylish_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ProductRepository repo = ProductRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const StylishAppBar(),
        body: Column(
          children: [
            BlocProvider(
              create: (context) => GetCampaignCubit(repo),
              child: BlocBuilder<GetCampaignCubit, ApiState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return const Center(child: Text("Loading"));
                  } else if (state is ApiSuccess) {
                    return BannerView(bannerList: state.data);
                  } else if (state is ApiError) {
                    return Center(
                        child: Text(state.errorCode).addAllPadding(20));
                  } else {
                    return const Center(child: Text("default"));
                  }
                },
              ),
            ),
            BlocProvider(
              create: (context) => GetProductListCubit(repo),
              child: BlocBuilder<GetProductListCubit, ApiState>(
                  builder: (context, state) {
                if (state is Loading) {
                  return const Center(child: Text("Loading"));
                } else if (state is ApiSuccess) {
                  return LayoutBuilder(builder: (context, constraints) {
                    return (constraints.maxWidth > 600)
                        ? WebProductView(state: state)
                        : AppProductListView(
                            productList: parseProductData(state.data));
                  });
                } else if (state is ApiError) {
                  return Center(child: Text(state.errorCode).addAllPadding(20));
                } else {
                  return const Center(child: Text("default"));
                }
              }),
            ).wrapByExpanded()
          ],
        ));
  }
}

class WebProductView extends StatelessWidget {
  final ApiSuccess state;

  const WebProductView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MutiProductListView(
            title: "女裝", list: parseProductData(state.data, type: "women")),
        MutiProductListView(
            title: "男裝", list: parseProductData(state.data, type: "men")),
        MutiProductListView(
            title: "配件",
            list: parseProductData(state.data, type: "accessories")),
      ],
    );
  }
}

class BannerView extends StatelessWidget {
  const BannerView({super.key, required this.bannerList});

  final List<Campaign> bannerList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: bannerList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: bannerList[index].picture,
                    fit: BoxFit.fitHeight,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator().addAllPadding(20),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ));
            }));
  }
}

class MutiProductListView extends StatelessWidget {
  const MutiProductListView(
      {super.key, required this.title, required this.list});

  final List<dynamic> list;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ListTitleView(title: title),
          Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemView(product: list[index]);
                }),
          )
        ],
      ),
    );
  }
}

class AppProductListView extends StatelessWidget {
  const AppProductListView({super.key, required this.productList});

  final List<dynamic> productList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              return ListTitleView(title: productList[index]);
            }
            return null;
          }),
    );
  }
}

class ListTitleView extends StatelessWidget {
  const ListTitleView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ));
  }
}

class ItemView extends StatelessWidget {
  const ItemView({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(product: product)),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Colors.black,
              width: 1.0,
            )),
        child: Row(
          children: [
            CachedNetworkImage(
              width: 80,
              fit: BoxFit.contain,
              imageUrl: product.mainImage,
              placeholder: (context, url) =>
                  const CircularProgressIndicator().addAllPadding(20),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(product.title), Text("NT\$ ${product.price}")],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
