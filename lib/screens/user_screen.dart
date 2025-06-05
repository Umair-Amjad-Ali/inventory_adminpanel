import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_adminpanel/constants/models/user_model.dart';
import 'package:inventory_adminpanel/controllers/user_controller.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final UserController controller = Get.put(UserController());
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  void showEditUserDialog(UserModel user, int index) {
    nameCtrl.text = user.fullName;
    emailCtrl.text = user.email;
    phoneCtrl.text = user.phoneNumber;

    final bgColor = Theme.of(Get.context!).scaffoldBackgroundColor;

    showDialog(
      context: Get.context!,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit User'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      // labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: bgColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      // labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: bgColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneCtrl,
                    decoration: InputDecoration(
                      // labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: bgColor,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final updatedUser = UserModel(
                    id: user.id,
                    fullName: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    phoneNumber: phoneCtrl.text.trim(),
                  );
                  controller.updateUser(index, updatedUser);
                  Get.back();
                },
                child: const Text('Save'),
              ),
              TextButton(onPressed: Get.back, child: const Text('Cancel')),
            ],
          ),
    );
  }

  Future<void> showDeleteConfirmationDialog(UserModel user, int index) async {
    final confirm = await showDialog<bool>(
      context: Get.context!,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text(
              'Are you sure you want to delete user ${user.fullName}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      controller.deleteUser(index);
      Get.snackbar('Deleted', 'User ${user.fullName} has been removed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name, email, or phone',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final users = controller.filteredUsers;
                if (users.isEmpty) {
                  return const Center(child: Text("No users found."));
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      child: ListTile(
                        title: Text("Name: ${user.fullName}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email: ${user.email}"),
                            Text("Phone: ${user.phoneNumber}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => showEditUserDialog(user, index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed:
                                  () =>
                                      showDeleteConfirmationDialog(user, index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
