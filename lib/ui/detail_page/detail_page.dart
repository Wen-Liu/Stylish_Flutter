import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stylish/data_class/get_product_response.dart';
import 'package:stylish/extensions.dart';
import 'package:stylish/ui/detail_page/detail_view_model.dart';
import 'package:stylish/ui/detail_page/stock_cubit.dart';
import 'package:stylish/ui/stylish_app_bar.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key, required this.product});

  final Product product;

  // final Product product = DetailViewModel();

  static const double webViewWidth = 760;
  static const double appViewWidth = 360;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const StylishAppBar(),
        body: SingleChildScrollView(
          child: LayoutBuilder(builder: (context, constraints) {
            return ((constraints.maxWidth > 780)
                    ? WebPageView(product: product, width: webViewWidth)
                    : AppPageView(product: product, width: appViewWidth))
                .addVerticalPadding(10);
          }),
        ));
  }
}

class WebPageView extends StatelessWidget {
  const WebPageView({super.key, required this.product, required this.width});

  final Product product;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: product.mainImage).expanded(),
            SelectView(product: product).addPadding(left: 16).expanded()
          ],
        ),
        StoryView(product: product)
      ],
    ).atCenter().wrapByContainer(width: 760);
  }
}

class AppPageView extends StatelessWidget {
  const AppPageView({super.key, required this.product, required this.width});

  final Product product;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(imageUrl: product.mainImage),
        SelectView(product: product).addPadding(top: 10),
        StoryView(product: product)
      ],
    ).atCenter().wrapByContainer(width: 360);
  }
}

class SelectView extends StatelessWidget {
  final Product product;

  const SelectView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            .addPadding(top: 5),
        CustomText(text: product.id.toString(), fontSize: 14)
            .addPadding(top: 3),
        Text(
          "NT\$ ${product.price}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ).addPadding(top: 12),
        const Divider(color: Colors.grey, thickness: 1).addPadding(top: 2),
        StockStateView(product: product),
        CustomText(text: product.note).addPadding(top: 10),
        CustomText(text: product.texture),
        CustomText(text: product.description),
        CustomText(text: "素材產地 / ${product.place}"),
        CustomText(text: "加工產地 / ${product.place}"),
      ],
    );
  }
}

class StockStateView extends StatelessWidget {
  const StockStateView({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StockCubit(product),
      child: BlocBuilder<StockCubit, StockData>(
        builder: (context, state) {
          return Column(
            children: [
              ColorView(context: context, data: state).addPadding(top: 10),
              SizeView(context: context, data: state).addPadding(top: 15),
              StockView(context: context, data: state).addPadding(top: 15),
              ConfirmBtnView(context: context, data: state).addPadding(top: 10),
            ],
          );
        },
      ),
    );
    // });
  }
}

class ColorView extends StatelessWidget {
  const ColorView({super.key, required this.context, required this.data});

  final BuildContext context;
  final StockData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomText(text: "顏色"),
        const VerticalLineView().addHorizontalPadding(10),
        for (ProductColor color in data.product.colors)
          InkWell(
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                    color: Color(int.parse(color.code, radix: 16) + 0xFF000000),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(1),
                    border: (color.code == data.color)
                        ? Border.all(color: Colors.black, width: 3)
                        : Border.all(color: Colors.grey, width: 1)), // 角半徑
              ).addPadding(right: 10),
              onTap: () {
                context.read<StockCubit>().setColor(color.code);
              })
      ],
    );
  }
}

class SizeView extends StatelessWidget {
  const SizeView({super.key, required this.context, required this.data});

  final BuildContext context;
  final StockData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomText(text: "尺寸"),
        const VerticalLineView().addHorizontalPadding(10),
        for (String size in data.product.sizes)
          ElevatedButton(
            style: TextButton.styleFrom(
                backgroundColor:
                    (size == data.size) ? Colors.white70 : Colors.black54,
                foregroundColor:
                    (size == data.size) ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                textStyle: const TextStyle(fontSize: 14)),
            child: Text(size),
            onPressed: () {
              context.read<StockCubit>().setSize(size);
            },
          ).addPadding(right: 8)
      ],
    );
  }
}

class StockView extends StatelessWidget {
  const StockView({super.key, required this.context, required this.data});

  final BuildContext context;
  final StockData data;

  @override
  Widget build(BuildContext context) {
    bool couldReduce = data.quantity > 0;
    bool couldAdd = data.quantity < data.stock;

    return Row(
      children: [
        const CustomText(text: "數量"),
        const VerticalLineView().addHorizontalPadding(10),
        IconButton(
                icon: const Icon(Icons.remove_circle),
                disabledColor: Colors.grey,
                onPressed: couldReduce
                    ? () {
                        context.read<StockCubit>().decrement();
                      }
                    : null)
            .expanded(),
        Text(data.quantity.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16))
            .expanded(flex: 3),
        IconButton(
                icon: const Icon(Icons.add_circle),
                disabledColor: Colors.grey,
                onPressed: couldAdd
                    ? () {
                        context.read<StockCubit>().increment();
                      }
                    : null)
            .expanded()
      ],
    );
  }
}

class ConfirmBtnView extends StatelessWidget {
  const ConfirmBtnView({super.key, required this.context, required this.data});

  final BuildContext context;
  final StockData data;

  @override
  Widget build(BuildContext context) {
    bool dataValid =
        data.color != "Default" && data.size != "Default" && data.quantity != 0;

    return Row(
      children: [
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: dataValid ? Colors.black87 : Colors.grey,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 20)),
          onPressed: () {},
          child: Text(getText()).addVerticalPadding(12),
        ).expanded()
      ],
    );
  }

  String getText() {
    List<String> list = [];
    if (data.color == "Default") list.add("顏色");
    if (data.size == "Default") list.add("尺寸");
    if (data.quantity == 0 && data.stock != 0) list.add("數量");

    if (list.isEmpty) {
      return (data.stock != 0) ? "加入購物車" : "已售完";
    } else {
      return "請選擇${list.join('、')}";
    }
  }
}

class VerticalLineView extends StatelessWidget {
  const VerticalLineView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      width: 1,
      height: 20,
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text, this.fontSize, this.color});

  final String text;
  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: fontSize ?? 16, color: color));
  }
}

class StoryView extends StatelessWidget {
  const StoryView({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const GradientColorText(text: "細部說明"),
            const SizedBox(width: 15),
            const Divider(color: Colors.black, thickness: 1).expanded()
          ],
        ).addPadding(top: 20, bottom: 5),
        Text(product.story),
        for (String image in product.images)
          CachedNetworkImage(imageUrl: image).addPadding(top: 16)
      ],
    );
  }
}

class GradientColorText extends StatelessWidget {
  const GradientColorText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
          stops: [0.0, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
