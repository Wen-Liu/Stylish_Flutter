import 'package:flutter/services.dart';

import 'data_class/card_info.dart';

class AndroidRepository {
  static const MethodChannel _channel = MethodChannel('Android_channel');

  static final AndroidRepository _instance = AndroidRepository._internal();

  factory AndroidRepository() {
    return _instance;
  }

  AndroidRepository._internal();

  Future<String> getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _channel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    return batteryLevel;
  }

  Future<bool> initTapPay() async {
    bool isSuccess = false;
    try {
      isSuccess = await _channel.invokeMethod('setupTappay', {
        'appId': 12348,
        'appKey':
            "app_pa1pQcKoY22IlnSXq5m5WP5jFKzoRG58VEXpT7wU62ud7mMbDOGzCYIlzzLF",
        'serverType': "sandBox"
      });
    } on PlatformException catch (e) {}

    return isSuccess;
  }

  Future<bool> validate(CardInfo cardInfo) async {
    bool isSuccess = false;
    try {
      isSuccess = await _channel.invokeMethod('isCardValid', {
        'cardNumber': cardInfo.number,
        'dueMonth': cardInfo.dueMonth,
        'dueYear': cardInfo.dueYear,
        "ccv": cardInfo.ccv
      });
    } on PlatformException catch (e) {}

    return isSuccess;
  }

  Future<String> getPrime(CardInfo cardInfo) async {
    String prime = "";
    try {
      prime = await _channel.invokeMethod('getPrime', {
        'cardNumber': cardInfo.number,
        'dueMonth': cardInfo.dueMonth,
        'dueYear': cardInfo.dueYear,
        "ccv": cardInfo.ccv
      });
    } on PlatformException catch (e) {}

    return prime;
  }
}
