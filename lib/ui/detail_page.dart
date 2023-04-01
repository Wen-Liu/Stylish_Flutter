import 'package:flutter/material.dart';
import 'package:stylish/data_class/product.dart';
import 'package:stylish/extensions.dart';
import 'package:stylish/ui/stylish_app_bar.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.product});

  final Product product;

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
    return Center(
        child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.mainImage).wrapByExpanded(),
            SelectView(product: product).addPadding(left: 16).wrapByExpanded()
          ],
        ),
        StoryView(product: product)
      ],
    ).wrapByContainer(width: 760));
  }
}

class AppPageView extends StatelessWidget {
  const AppPageView({super.key, required this.product, required this.width});

  final Product product;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Image.network(product.mainImage),
        SelectView(product: product).addPadding(top: 10),
        StoryView(product: product)
      ],
    ).wrapByContainer(width: 360));
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
        ColorView(colorList: product.colors).addPadding(top: 10),
        SizeView(sizeList: product.sizes).addPadding(top: 15),
        const StockView().addPadding(top: 15),
        Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {},
              child: const Text('請選擇尺寸').addAllPadding(12),
            ).wrapByExpanded()
          ],
        ).addPadding(top: 10),
        CustomText(text: product.note).addPadding(top: 10),
        CustomText(text: product.texture),
        CustomText(text: product.description),
        CustomText(text: "素材產地 / ${product.place}"),
        CustomText(text: "加工產地 / ${product.place}"),
      ],
    );
  }
}

class ColorView extends StatelessWidget {
  const ColorView({
    super.key,
    required this.colorList,
  });

  final List<ProductColors> colorList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomText(text: "顏色"),
        const VerticalLineView().addHorizontalPadding(10),
        for (ProductColors color in colorList)
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
                color: Color(int.parse(color.code, radix: 16) + 0xFF000000),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(1),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                )), // 角半徑
          ).addPadding(right: 10)
      ],
    );
  }
}

class SizeView extends StatelessWidget {
  const SizeView({
    super.key,
    required this.sizeList,
  });

  final List<String> sizeList;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomText(text: "尺寸"),
        const VerticalLineView().addHorizontalPadding(10),
        for (String size in sizeList)
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                textStyle: const TextStyle(fontSize: 14)),
            child: Text(size), //
            onPressed: () {},
          ).wrapByContainer(width: 36, height: 24).addPadding(right: 8)
      ],
    );
  }
}

class StockView extends StatelessWidget {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomText(text: "數量"),
        const VerticalLineView().addHorizontalPadding(10),
        IconButton(onPressed: () {}, icon: const Icon(Icons.remove_circle))
            .wrapByExpanded(),
        const Text("123",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16))
            .wrapByExpanded(flex: 3),
        IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle))
            .wrapByExpanded()
      ],
    );
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
          children: const [
            ColorText(text: "細部說明"),
            SizedBox(width: 15),
            Expanded(child: Divider(color: Colors.black, thickness: 1))
          ],
        ).addPadding(top: 20, bottom: 5),
        Text(product.story),
        for (String image in product.images)
          Image.network(image).addPadding(top: 16)
      ],
    );
  }
}

class ColorText extends StatelessWidget {
  const ColorText({super.key, required this.text});

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
