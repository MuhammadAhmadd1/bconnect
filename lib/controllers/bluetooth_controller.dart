import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  bool isScanning = false;

  // To scan devices for Bluetooth connection
  void scanDevices() async {
    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    ).then((_) {
      // After the scan completes, set isScanning to false and update the UI.
      isScanning = false;
      update(); // Notify listeners to rebuild the UI and hide the loader.
    });
    FlutterBluePlus.scanResults.listen((results) {
      // Update your UI or state with the results.
      // For instance, if using GetX, you can call update() here
      isScanning = true;
      update(); // This will notify listeners
    });
    // Use a timeout to stop the scan after a delay.
    await Future.delayed(const Duration(seconds: 5));

    //after the scan we need to stop the scan
    FlutterBluePlus.stopScan();
  }

  //now showing all available devices
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}
