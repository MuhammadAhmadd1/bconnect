import 'package:bconnect/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _enable = true;

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
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _enable = !_enable;
                      });
                      controller.scanDevices();
                    },
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
                    label: const Text(
                      'Scan',
                      style: TextStyle(fontSize: 28),
                    ),
                    icon: Icon(
                      _enable
                          ? Icons.hourglass_bottom_rounded
                          : Icons.hourglass_disabled_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<List<ScanResult>>(
                  // Listening to the stream of scan results provided by the controller
                  stream: controller.scanResults,
                  // The builder function to construct the UI based on the snapshot data
                  builder: (context, snapshot) {
                    // Show skeleton loading state while waiting for scan results
                    if (snapshot.connectionState == ConnectionState.waiting || _enable) {
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 5, // Skeletons for 5 loading items
                          itemBuilder: (context, index) {
                            return const Card(
                              elevation: 2,
                              child: ListTile(
                                leading: Icon(Icons.ac_unit),
                                title: Text("Loading..."),
                                subtitle: Text("Loading..."),
                                trailing: Text("..."),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    // Check if the snapshot contains data after scanning completes
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data![index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              leading: const Icon(Icons.bluetooth),
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
