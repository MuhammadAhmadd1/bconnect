import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  // To scan devices for Bluetooth connection
  void scanDevices() async{
    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 15),
    );
      FlutterBluePlus.scanResults.listen((results) {
    // Update your UI or state with the results.
    // For instance, if using GetX, you can call update() here
    update(); // This will notify listeners
  });
      // Use a timeout to stop the scan after a delay.
  await Future.delayed(const Duration(seconds: 10));

    //after the scan we need to stop the scan
    FlutterBluePlus.stopScan();
  }

  //now showing all available devices
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}
