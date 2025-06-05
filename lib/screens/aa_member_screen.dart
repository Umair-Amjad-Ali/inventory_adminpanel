import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/aaa_member_controller.dart';

class AaMemberScreen extends StatelessWidget {
  AaMemberScreen({super.key});
  final AaMemberController controller = Get.put(AaMemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AAA Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add AAA Member',
            onPressed: () => _showAddMemberDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.members.isEmpty) {
            return const Text('No AAA Members found.');
          }
          return ListView.builder(
            itemCount: controller.members.length,
            itemBuilder: (context, index) {
              final user = controller.members[index];
              return Card(
                child: ListTile(
                  title: Text('Name: ${user['fullName'] ?? ''}'),
                  subtitle: Text('Email: ${user['email'] ?? ''}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Member',
                        style: TextStyle(color: Colors.green),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        tooltip: 'Remove AAA Membership',
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text('Confirm Removal'),
                                  content: Text(
                                    'Are you sure you want to remove AAA membership from ${user['fullName']}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            await controller.removeAAAMember(user['id']);
                            // Get.snackbar('Success', 'AAA membership removed.');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final searchController = TextEditingController();
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Add AAA Member'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name or email',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: bgColor,
                    ),
                    onChanged: controller.searchUsers,
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final results =
                        controller.searchQuery.value.isEmpty
                            ? []
                            : controller.searchResults;

                    if (results.isEmpty) return const Text('No users found.');

                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final user = results[index];
                          final isMember = user['isAAAMember'] == true;

                          return ListTile(
                            title: Text('Name: ${user['fullName'] ?? ''}'),
                            subtitle: Text('Email: ${user['email'] ?? ''}'),
                            trailing:
                                isMember
                                    ? const Text(
                                      'Already Member',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                    : ElevatedButton(
                                      onPressed: () async {
                                        await controller.markAsAAAMember(
                                          user['id'],
                                        );
                                        Navigator.pop(context); // Close dialog
                                      },
                                      child: const Text('Mark as Member'),
                                    ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
