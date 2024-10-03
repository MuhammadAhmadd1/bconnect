import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  bool isScanning = false;

  // To scan devices for Bluetooth connection
  void scanDevices() async {
    isScanning = true;
    update(); // Notify listeners to show loader
    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );
    FlutterBluePlus.scanResults.listen((results) {
      // This will notify listeners when devices are found
      isScanning = true;
      update(); // This will notify listeners
    });
    // Use a timeout to stop the scan after a delay.
    await Future.delayed(const Duration(seconds: 5));

    FlutterBluePlus.stopScan();
    isScanning = false;
    update(); // Notify listeners to hide loader after scan completes
  }

  //now showing all available devices
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}
