import 'package:bconnect/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.green,
                  title: const Text(
                    "bConnect",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () => controller.scanDevices(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      minimumSize: const Size(150, 50),
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(2),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Scan',
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                    if (controller.isScanning)
                  Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: Colors.green,
                      size: 50,
                    ),
                  )
                else
                const SizedBox(height: 20),
                StreamBuilder<List<ScanResult>>(
                  // Listening to the stream of scan results provided by the controller
                  stream: controller.scanResults,
                  // The builder function to construct the UI based on the snapshot data
                  builder: (context, snapshot) {
                    // Check if the snapshot contains data
                    if (snapshot.hasData) {
                      return ListView.builder(
                        // Allow the ListView to take only the space it needs
                        shrinkWrap: true,
                        // Set the number of items to the length of the data in the snapshot
                        itemCount: snapshot.data!.length,
                        // Callback to build each item in the ListView
                        itemBuilder: (context, index) {
                          final data = snapshot.data![index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              //By using platformName,
                              //you can ensure that your app behaves appropriately across different devices and platforms.
                              // Displays the platform name of the device as the main title.
                              title: Text(
                                data.device.platformName,
                                style: const TextStyle(color: Colors.black),
                              ),
                              // Displays the remote ID of the device as a subtitle.
                              subtitle: Text(
                                data.device.remoteId.str,
                                style: const TextStyle(color: Colors.black),
                              ),
                              // Displays the RSSI (Received Signal Strength Indicator) value as trailing text
                              trailing: Text(
                                data.rssi.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No Devices Found',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
