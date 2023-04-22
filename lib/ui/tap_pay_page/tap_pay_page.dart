import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class TapPayPage extends StatefulWidget {
  const TapPayPage({super.key});

  @override
  State<TapPayPage> createState() => _TapPayPageState();
}

class _TapPayPageState extends State<TapPayPage> {
  static const platform = MethodChannel("Android_channel");
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    print("_getBatteryLevel= $_batteryLevel");

    String batteryLevel;
    try {
      print("_getBatteryLevel=  2");
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      print("_getBatteryLevel=  3");
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    print("_getBatteryLevel= $_batteryLevel 2");

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
            Text(_batteryLevel),
          ],
        ),
      ),
    );
  }
}
