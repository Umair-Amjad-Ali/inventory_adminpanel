import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_adminpanel/controllers/station_truck_controller.dart';

class StationTruckScreen extends StatelessWidget {
  StationTruckScreen({super.key});
  final StationTruckController controller = Get.put(StationTruckController());
  static final TextEditingController searchController = TextEditingController();
  final TextEditingController stationController = TextEditingController();

  void showAddStationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '➕ Add New Station',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: stationController,
                        decoration: InputDecoration(
                          // labelText: 'Station Name',
                          hintText: 'Enter station name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              controller.addStation(
                                stationController.text.trim(),
                              );
                              stationController.clear();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Station & Truck Passcode Assignment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Search User by Email, Name or Phone"),
              const SizedBox(height: 8),
              TextField(
                controller: searchController,
                onChanged: (val) => controller.searchUsersByText(val),
                decoration: const InputDecoration(
                  hintText: "Type name, email or phone...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              if (controller.userSearchResults.isNotEmpty)
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    itemCount: controller.userSearchResults.length,
                    itemBuilder: (_, i) {
                      final user = controller.userSearchResults[i];
                      final isSelected =
                          controller.selectedUser.value?['uid'] == user['uid'];
                      return Container(
                        color:
                            isSelected
                                ? Colors.green.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.1),
                        child: ListTile(
                          title: Text(user['fullName'] ?? 'No Name'),
                          subtitle: Text(user['email']),

                          trailing:
                              isSelected
                                  ? ElevatedButton(
                                    onPressed:
                                        () => controller.selectUser(user),
                                    child: const Text("Select"),
                                  )
                                  : Text(
                                    "User is Already Selected",
                                    style: TextStyle(color: Colors.green),
                                  ),
                        ),
                      );
                    },
                  ),
                ),

              // const Divider(height: 12),
              if (controller.selectedUser.value != null)
                Text(
                  "Selected User: ${controller.selectedUser.value!['email']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

              const SizedBox(height: 16),
              const Text("Select Station"),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
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
                      onChanged:
                          (val) => controller.selectedStation.value = val,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: "Add new station",
                    onPressed: () => showAddStationDialog(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: "Delete selected station",
                    onPressed:
                        controller.selectedStation.value != null
                            ? () => controller.deleteStation(
                              controller.selectedStation.value!,
                            )
                            : null,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text("Assign Truck Passcode"),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => controller.passcodeController.value = v,
                      decoration: InputDecoration(
                        hintText: 'Enter or generate passcode',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: "Generate random passcode",
                          onPressed: () {
                            controller.passcodeController.value =
                                controller.generateRandomPasscode();
                          },
                        ),
                      ),
                      controller: TextEditingController(
                        text: controller.passcodeController.value,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                icon: const Icon(Icons.check),
                label: const Text("Assign Passcode"),
                onPressed: controller.assignPasscodeToUser,
              ),

              const Divider(height: 32),
              const Text(
                "🚛 Active Users with Passcodes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child:
                    controller.activeUsers.isEmpty
                        ? const Center(child: Text("No active users yet."))
                        : ListView.builder(
                          itemCount: controller.activeUsers.length,
                          itemBuilder: (_, i) {
                            final user = controller.activeUsers[i];
                            final isUsed = user['isUsed'] == true;

                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.circle,
                                  color: isUsed ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                title: Text("Name: ${user['fullName']}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Email: ${user['email']}"),
                                    Text("Passcode: ${user['passcode']}"),
                                    Text("Station: ${user['station']}"),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.logout),
                                  tooltip:
                                      isUsed
                                          ? "Logout this user"
                                          : "Already logged out",
                                  onPressed:
                                      isUsed
                                          ? () => controller.logoutUser(
                                            user['docId'],
                                          )
                                          : null,
                                  color: isUsed ? Colors.red : Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
