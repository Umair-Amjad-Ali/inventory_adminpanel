import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_adminpanel/controllers/truck/truck_controller.dart';

class TruckScreen extends StatelessWidget {
  final TruckController truckController = Get.put(TruckController());

  TruckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Truck Management')),
      body: Obx(() {
        if (truckController.trucks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Mobile View
        if (screenWidth < 600) {
          return ListView.builder(
            itemCount: truckController.trucks.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final truck = truckController.trucks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 62, 61, 61),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            color: Colors.blue.shade700,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Truck #: ${truck['truckNumber']}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.storage_rounded, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Capacity: ${truck['capacity']}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.battery_charging_full,
                            color: Colors.green.shade800,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Batteries: ${truck['batteries']}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                      Divider(
                        height: 20,
                        thickness: 0.8,
                        color: Colors.grey.shade300,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => showEditDialog(context, truck),
                          icon: Icon(Icons.edit, size: 18),
                          label: Text("Edit"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (_) => const Color.fromARGB(255, 36, 36, 36),
                    ),
                    columns: const [
                      DataColumn(label: Text('Truck Number')),
                      DataColumn(label: Text('Capacity')),
                      DataColumn(label: Text('Batteries')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        truckController.trucks.map<DataRow>((truck) {
                          return DataRow(
                            cells: [
                              DataCell(Text(truck['truckNumber'])),
                              DataCell(Text(truck['capacity'].toString())),
                              DataCell(Text(truck['batteries'].toString())),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed:
                                      () => showEditDialog(context, truck),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void showEditDialog(BuildContext context, Map<String, dynamic> truck) {
    final batteriesController = TextEditingController(
      text: truck['batteries'].toString(),
    );
    final capacityController = TextEditingController(text: truck['capacity']);
    final truckNumberController = TextEditingController(
      text: truck['truckNumber'],
    );
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Edit Truck ${truck['id']}"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: SizedBox(
              width: screenWidth < 500 ? screenWidth * 0.9 : 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  customTextField(
                    controller: truckNumberController,
                    label: "Truck Number",
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: capacityController,
                    label: "Capacity",
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: batteriesController,
                    label: "Batteries",
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final updatedData = {
                    'truckNumber': truckNumberController.text.trim(),
                    'capacity': capacityController.text.trim(),
                    'batteries':
                        int.tryParse(batteriesController.text.trim()) ?? 0,
                  };
                  await truckController.updateTruck(truck['id'], updatedData);
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}
