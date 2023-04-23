import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:stylish/data_class/card_info.dart';
import 'package:stylish/extensions.dart';
import 'package:stylish/network/product_repository.dart';
import 'package:stylish/ui/stylish_app_bar.dart';
// import 'package:flutter_tappay/flutter_tappay.dart';

class TapPayPage extends StatefulWidget {
  const TapPayPage({super.key});

  @override
  State<TapPayPage> createState() => _TapPayPageState();
}

class _TapPayPageState extends State<TapPayPage> {
  static const platform = MethodChannel("Android_channel");

  // static FlutterTappay payer = FlutterTappay();
  String _batteryLevel = 'Unknown battery level.';
  bool _isInitSuccess = false;
  bool _isCardValidate = false;
  String _prime = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const StylishAppBar(),
        body: Column(children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: _getBatteryLevel,
                child: const Text('Get Battery Level'),
              ).addPadding(top: 20),
              Text(_batteryLevel),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                child: const Text("init tappay"),
                onPressed: () {
                  initTapPay();
                },
              ).addPadding(top: 20),
              Text("init TapPay Success: $_isInitSuccess"),
              ElevatedButton(
                child: const Text("Validate"),
                onPressed: () {
                  validate(CardInfo());
                },
              ).addPadding(top: 20),
              Text("Validate Card Success: $_isCardValidate"),
              ElevatedButton(
                child: const Text("get getPrime"),
                onPressed: () {
                  getPrime(CardInfo());
                },
              ).addPadding(top: 20),
              Text("get Prime: $_prime").addHorizontalPadding(30),
            ],
          ).atCenter().expanded()
        ]));
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> initTapPay() async {
    bool isSuccess = false;
    try {
      isSuccess = await platform.invokeMethod('setupTappay', {
        'appId': 12348,
        'appKey':
            "app_pa1pQcKoY22IlnSXq5m5WP5jFKzoRG58VEXpT7wU62ud7mMbDOGzCYIlzzLF",
        'serverType': "sandBox"
      });
    } on PlatformException catch (e) {}

    setState(() {
      _isInitSuccess = isSuccess;
    });
  }

  Future<void> validate(CardInfo cardInfo) async {
    bool isSuccess = false;
    try {
      isSuccess = await platform.invokeMethod('isCardValid', {
        'cardNumber': cardInfo.number,
        'dueMonth': cardInfo.dueMonth,
        'dueYear': cardInfo.dueYear,
        "ccv": cardInfo.ccv
      });
    } on PlatformException catch (e) {}

    setState(() {
      _isCardValidate = isSuccess;
    });
  }

  Future<void> getPrime(CardInfo cardInfo) async {
    String prime = "";
    try {
      prime = await platform.invokeMethod('getPrime', {
        'cardNumber': cardInfo.number,
        'dueMonth': cardInfo.dueMonth,
        'dueYear': cardInfo.dueYear,
        "ccv": cardInfo.ccv
      });
    } on PlatformException catch (e) {}

    setState(() {
      _prime = prime;
    });
  }
}
