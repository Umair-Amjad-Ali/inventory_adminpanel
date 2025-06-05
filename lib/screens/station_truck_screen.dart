import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_adminpanel/controllers/station_truck_controller.dart';

class StationTruckScreen extends StatelessWidget {
  StationTruckScreen({super.key});

  final StationTruckController controller = Get.put(StationTruckController());
  final TextEditingController truckController = TextEditingController();
  final TextEditingController newStationController = TextEditingController();

  void showAddStationDialog(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Add New Station'),
            content: SizedBox(
              width: 400,
              child: TextField(
                controller: newStationController,
                decoration: InputDecoration(
                  hintText: 'Station Name',
                  prefixIcon: const Icon(Icons.location_city),
                  filled: true,
                  fillColor: bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.addStation(newStationController.text.trim());
                  newStationController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void showEditTruckDialog(BuildContext context, int index, String truck) {
    final TextEditingController editController = TextEditingController(
      text: truck,
    );
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Truck'),
            content: TextField(
              controller: editController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.editTruck(index, editController.text.trim());
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Station & Truck Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined),
            onPressed: () => showAddStationDialog(context),
          ),
          Obx(() {
            if (controller.selectedStation.value == null) {
              return const SizedBox();
            }
            return IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: "Delete selected station",
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text("Delete Station"),
                        content: Text(
                          "Are you sure you want to delete station '${controller.selectedStation.value}'? All trucks will be lost.",
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              controller.deleteStation(
                                controller.selectedStation.value!,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text("Delete"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                );
              },
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Station',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: controller.selectedStation.value,
                hint: const Text('Choose a station'),
                items:
                    controller.stations
                        .map(
                          (station) => DropdownMenuItem(
                            value: station,
                            child: Text(station),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  if (val != null) controller.onStationSelected(val);
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Text(
                'Truck Passcode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: truckController,
                decoration: const InputDecoration(
                  hintText: 'Enter truck passcode',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.selectedStation.value == null ||
                        truckController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please select a station and enter truck number",
                          ),
                        ),
                      );
                      return;
                    }
                    controller.addTruck(truckController.text.trim());
                    truckController.clear();
                  },
                  child: const Text('Add Truck'),
                ),
              ),
              const SizedBox(height: 24),
              if (controller.selectedStation.value != null)
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.passCodes.length,
                      itemBuilder: (context, index) {
                        final truck = controller.passCodes[index];
                        return Card(
                          child: ListTile(
                            title: Text(truck),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed:
                                      () => showEditTruckDialog(
                                        context,
                                        index,
                                        truck,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => AlertDialog(
                                            title: const Text("Delete Truck"),
                                            content: Text(
                                              "Are you sure you want to delete truck '$truck'?",
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  controller.deleteTruck(truck);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Delete"),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: const Text("Cancel"),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
