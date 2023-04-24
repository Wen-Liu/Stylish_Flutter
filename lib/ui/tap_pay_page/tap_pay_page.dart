import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:stylish/android_repository.dart';
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
  String _batteryLevel = 'Unknown battery level.';
  bool _isInitSuccess = false;
  bool _isCardValidate = false;
  String _prime = "default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const StylishAppBar(),
        body: Column(children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  String batteryLevel =
                      await AndroidRepository().getBatteryLevel();
                  setState(() {
                    _batteryLevel = batteryLevel;
                  });
                },
                child: const Text('Get Battery Level'),
              ).addPadding(top: 20),
              Text(_batteryLevel),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                child: const Text("Init tappay"),
                onPressed: () async {
                  bool isSuccess = await AndroidRepository().initTapPay();
                  setState(() {
                    _isInitSuccess = isSuccess;
                  });
                },
              ).addPadding(top: 20),
              Text("Init TapPay Success: $_isInitSuccess"),
              ElevatedButton(
                child: const Text("Validate Card"),
                onPressed: () async {
                  bool isSuccess =
                      await AndroidRepository().validate(CardInfo());
                  setState(() {
                    _isCardValidate = isSuccess;
                  });
                },
              ).addPadding(top: 20),
              Text("Validate Card Success: $_isCardValidate"),
              ElevatedButton(
                child: const Text("Get Prime"),
                onPressed: () async {
                  String prime = await AndroidRepository().getPrime(CardInfo());
                  setState(() {
                    _prime = prime;
                  });
                },
              ).addPadding(top: 20),
              Text("Result: $_prime").addHorizontalPadding(30),
            ],
          ).atCenter().expanded()
        ]));
  }
}
