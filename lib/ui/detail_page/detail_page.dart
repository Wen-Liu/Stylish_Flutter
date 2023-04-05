import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylish/data_class/product.dart';
import 'package:stylish/extensions.dart';
import 'package:stylish/ui/detail_page/detail_view_model.dart';
import 'package:stylish/ui/stylish_app_bar.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key, required this.product});

  final Product product;
  final DetailViewModel viewModel = DetailViewModel();

  static const double webViewWidth = 760;
  static const double appViewWidth = 360;

  @override
  Widget build(BuildContext context) {
    viewModel.setProduct(product);

    return ChangeNotifierProvider(
        create: (context) => viewModel,
        child: Scaffold(
            appBar: const StylishAppBar(),
            body: SingleChildScrollView(
              child: LayoutBuilder(builder: (context, constraints) {
                return ((constraints.maxWidth > 780)
                        ? WebPageView(viewModel: viewModel, width: webViewWidth)
                        : AppPageView(
                            viewModel: viewModel, width: appViewWidth))
                    .addVerticalPadding(10);
              }),
            )));
  }
}

class WebPageView extends StatelessWidget {
  const WebPageView({super.key, required this.viewModel, required this.width});

  final DetailViewModel viewModel;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(viewModel.product.mainImage).wrapByExpanded(),
            SelectView(viewModel: viewModel)
                .addPadding(left: 16)
                .wrapByExpanded()
          ],
        ),
        StoryView(viewModel: viewModel)
      ],
    ).wrapByContainer(width: 760));
  }
}

class AppPageView extends StatelessWidget {
  const AppPageView({super.key, required this.viewModel, required this.width});

  final DetailViewModel viewModel;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Image.network(viewModel.product.mainImage),
        SelectView(viewModel: viewModel).addPadding(top: 10),
        StoryView(viewModel: viewModel)
      ],
    ).wrapByContainer(width: 360));
  }
}

class SelectView extends StatelessWidget {
  final DetailViewModel viewModel;

  const SelectView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(viewModel.product.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            .addPadding(top: 5),
        CustomText(text: viewModel.product.id.toString(), fontSize: 14)
            .addPadding(top: 3),
        Text(
          "NT\$ ${viewModel.product.price}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ).addPadding(top: 12),
        const Divider(color: Colors.grey, thickness: 1).addPadding(top: 2),
        StockStateView(viewModel: viewModel),
        CustomText(text: viewModel.product.note).addPadding(top: 10),
        CustomText(text: viewModel.product.texture),
        CustomText(text: viewModel.product.description),
        CustomText(text: "素材產地 / ${viewModel.product.place}"),
        CustomText(text: "加工產地 / ${viewModel.product.place}"),
      ],
    );
  }
}

class StockStateView extends StatefulWidget {
  const StockStateView({super.key, required this.viewModel});

  final DetailViewModel viewModel;

  @override
  State<StockStateView> createState() => _StockStateViewState();
}

class _StockStateViewState extends State<StockStateView> {
  @override
  Widget build(BuildContext context) {
    // return Consumer<DetailViewModel>(builder: (context, dataModel, child) {
      return Column(
        children: [
          ColorView(viewModel: widget.viewModel).addPadding(top: 10),
          SizeView(viewModel: widget.viewModel).addPadding(top: 15),
          StockView(viewModel: widget.viewModel).addPadding(top: 15),
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {},
                child: const Text('請選擇尺寸').addVerticalPadding(12),
              ).wrapByExpanded()
            ],
          ).addPadding(top: 10),
        ],
      );
    // });
  }
}

class ColorView extends StatelessWidget {
  const ColorView({super.key, required this.viewModel});

  final DetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel.currentColor,
      builder: (BuildContext context, value, Widget? child) {
        return Row(
          children: [
            const CustomText(text: "顏色"),
            const VerticalLineView().addHorizontalPadding(10),
            for (ProductColor color in viewModel.product.colors)
              InkWell(
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                        color: Color(
                            int.parse(color.code, radix: 16) + 0xFF000000),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(1),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        )), // 角半徑
                  ).addPadding(right: 10),
                  onTap: () {
                    viewModel.setColor(color);
                  })
          ],
        );
      },
    );
  }
}

class SizeView extends StatelessWidget {
  const SizeView({super.key, required this.viewModel});

  final DetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: viewModel.currentSize,
        builder: (BuildContext context, value, Widget? child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(text: "尺寸"),
              const VerticalLineView().addHorizontalPadding(10),
              for (String size in viewModel.product.sizes)
                ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: (size == viewModel.currentSize.value)
                          ? Colors.white70
                          : Colors.black54,
                      foregroundColor: (size == viewModel.currentSize.value)
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      textStyle: const TextStyle(fontSize: 14)),
                  child: Text(size),
                  onPressed: () {
                    viewModel.setSize(size);
                  },
                ).addPadding(right: 8)
            ],
          );
        });
  }
}

class StockView extends StatelessWidget {
  const StockView({super.key, required this.viewModel});

  final DetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: viewModel.currentQuantity,
        builder: (BuildContext context, value, Widget? child) {
          bool couldReduce = viewModel.currentQuantity.value > 0;
          bool couldAdd =
              viewModel.currentQuantity.value < viewModel.currentStock.value;

          print(
              "currentQuantity=${viewModel.currentQuantity.value}, Stock=${viewModel.currentStock}");
          return Row(
            children: [
              const CustomText(text: "數量"),
              const VerticalLineView().addHorizontalPadding(10),
              IconButton(
                      icon: const Icon(Icons.remove_circle),
                      disabledColor: Colors.grey,
                      onPressed: couldReduce
                          ? () {
                              viewModel.changeQuantity(-1);
                            }
                          : null)
                  .wrapByExpanded(),
              Text(viewModel.currentQuantity.value.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16))
                  .wrapByExpanded(flex: 3),
              IconButton(
                      icon: const Icon(Icons.add_circle),
                      disabledColor: Colors.grey,
                      onPressed: couldAdd
                          ? () {
                              viewModel.changeQuantity(1);
                            }
                          : null)
                  .wrapByExpanded()
            ],
          );
        });
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
  const StoryView({super.key, required this.viewModel});

  final DetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const GradientColorText(text: "細部說明"),
            const SizedBox(width: 15),
            const Divider(color: Colors.black, thickness: 1).wrapByExpanded()
          ],
        ).addPadding(top: 20, bottom: 5),
        Text(viewModel.product.story),
        for (String image in viewModel.product.images)
          Image.network(image).addPadding(top: 16)
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
