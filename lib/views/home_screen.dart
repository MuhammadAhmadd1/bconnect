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
                  height: 90,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () => controller.scanDevices(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      minimumSize: const Size(250, 50),
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
                const SizedBox(height: 150),
                if (controller.isScanning)
                  Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: Colors.green,
                      size: 50,
                    ),
                  )
                else
                  StreamBuilder<List<ScanResult>>(
                    stream: controller.scanResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active &&
                          snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(
                                  data.device.platformName,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  data.device.remoteId.str,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                trailing: Text(
                                  data.rssi.toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (!controller.isScanning && (!snapshot.hasData || snapshot.data!.isEmpty)) {
                        return const Center(
                          child: Text(
                            'No Devices Found',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
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
