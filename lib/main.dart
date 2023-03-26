import 'package:flutter/material.dart';
import 'package:stylish/Cloth';

void main() {
  var a = Cloth("123", 13, "13");
  runApp(const MyApp());
}

void createData() {
  var a = ClothList("女裝", List<Cloth>.filled(3, Cloth("123", 13, "13")));
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
        body: Column(
          children: [
            const CustomListView(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CustomVerticalListView(title: "女裝"),
                CustomVerticalListView(title: "男裝"),
                CustomVerticalListView(title: "配件")
              ],
            ),
          ],
        ));
  }
}

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return const Text("text");
          }),
    );
  }
}

class CustomVerticalListView extends StatelessWidget {
  const CustomVerticalListView({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold)));
              default:
                return const Item();
            }
          }),
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    super.key,
  });

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
            'images/item_image.jpeg',
            width: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [Text("UNIQLO 特級極輕羽絨外套"), Text("NT\$ 323")],
            ),
          )
        ],
      ),
    );
  }
}
