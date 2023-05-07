import 'package:flutter/material.dart';
import 'package:stylish/ui/stylish_app_bar.dart';
import 'call_sample/call_sample.dart';
import 'call_sample/data_channel_sample.dart';
import 'route_item.dart';

class WebRtcPage extends StatefulWidget {
  const WebRtcPage({super.key});

  @override
  State<WebRtcPage> createState() => _WebRtcState();
}

enum DialogDemoAction {
  cancel,
  connect,
}

class _WebRtcState extends State<WebRtcPage> {
  List<RouteItem> items = [];

  // String _server = '';
  // late SharedPreferences _prefs;

  bool _datachannel = false;

  @override
  initState() {
    super.initState();
    // _initData();
    _initItems();
  }

  _buildRow(context, item) {
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(item.title),
        onTap: () => item.push(context),
        trailing: Icon(Icons.arrow_right),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: const StylishAppBar(),
          body: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: items.length,
              itemBuilder: (context, i) {
                return _buildRow(context, items[i]);
              })),
    );
  }

  // _initData() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _server = _prefs.getString('server') ?? 'demo.cloudwebrtc.com';
  //   });
  // }

  void showDemoDialog<T>(
      {required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
      print("showDemoDialog $value");
      if (value != null) {
        if (value == DialogDemoAction.connect) {
          // _prefs.setString('server', _server);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => _datachannel
                      ? DataChannelSample(host: "demo.cloudwebrtc.com")
                      : CallSample(host: "demo.cloudwebrtc.com")));
        }
      }
    });
  }

  // _showAddressDialog(context) {
  //   showDemoDialog<DialogDemoAction>(
  //       context: context,
  //       child: AlertDialog(
  //           title: const Text('Enter server address:'),
  //           content: TextField(
  //             onChanged: (String text) {
  //               setState(() {
  //                 _server = text;
  //               });
  //             },
  //             decoration: InputDecoration(
  //               hintText: "demo.cloudwebrtc.com",
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //                 child: const Text('CANCEL'),
  //                 onPressed: () {
  //                   Navigator.pop(context, DialogDemoAction.cancel);
  //                 }),
  //             TextButton(
  //                 child: const Text('CONNECT'),
  //                 onPressed: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (BuildContext context) => _datachannel
  //                               ? DataChannelSample(host: "demo.cloudwebrtc.com")
  //                               : CallSample(host: "demo.cloudwebrtc.com")));
  //                 })
  //           ]));
  // }

  _initItems() {
    items = <RouteItem>[
      RouteItem(
          title: 'P2P Call Sample',
          subtitle: 'P2P Call Sample.',
          push: (BuildContext context) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CallSample(host: "demo.cloudwebrtc.com")));
          }),
      RouteItem(
          title: 'Data Channel Sample',
          subtitle: 'P2P Data Channel.',
          push: (BuildContext context) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DataChannelSample(host: "demo.cloudwebrtc.com")));
          }),
    ];
  }
}
