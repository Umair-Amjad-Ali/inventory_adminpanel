// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:inventory_adminpanel/constants/models/payment.dart';
// import 'package:inventory_adminpanel/controllers/payment_controller.dart';

// // ignore: must_be_immutable
// class PaymentScreen extends StatelessWidget {
//   PaymentScreen({super.key});

//   final PaymentController controller = Get.put(PaymentController());
//   final TextEditingController userController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final List<String> statusOptions = ['Paid', 'Pending', 'Failed'];
//   String selectedStatus = 'Paid';

//   void handleAddPayment(BuildContext context) {
//     final user = userController.text.trim();
//     final amount = double.tryParse(amountController.text.trim()) ?? 0;

//     if (user.isEmpty || amount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter valid user and amount')),
//       );
//       return;
//     }

//     controller.addPayment(user, amount, DateTime.now(), selectedStatus);
//     userController.clear();
//     amountController.clear();
//   }

//   void showEditDialog(BuildContext context, int index, Payment payment) {
//     final TextEditingController userEdit = TextEditingController(
//       text: payment.user,
//     );
//     final TextEditingController amountEdit = TextEditingController(
//       text: payment.amount.toString(),
//     );
//     String editStatus = payment.status;

//     showDialog(
//       context: context,
//       builder:
//           (_) => AlertDialog(
//             title: const Text('Edit Payment'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: userEdit,
//                   decoration: const InputDecoration(labelText: 'User'),
//                 ),
//                 TextField(
//                   controller: amountEdit,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Amount'),
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: editStatus,
//                   items:
//                       statusOptions
//                           .map(
//                             (status) => DropdownMenuItem(
//                               value: status,
//                               child: Text(status),
//                             ),
//                           )
//                           .toList(),
//                   onChanged: (value) => editStatus = value ?? 'Paid',
//                   decoration: const InputDecoration(labelText: 'Status'),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   controller.editPayment(
//                     index,
//                     Payment(
//                       user: userEdit.text,
//                       amount:
//                           double.tryParse(amountEdit.text) ?? payment.amount,
//                       date: DateTime.now(),
//                       status: editStatus,
//                     ),
//                   );
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Save'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: const Text('Payment Management')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Add New Payment',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: userController,
//               decoration: const InputDecoration(labelText: 'User'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: amountController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: 'Amount'),
//             ),
//             const SizedBox(height: 8),
//             DropdownButtonFormField<String>(
//               value: selectedStatus,
//               items:
//                   statusOptions
//                       .map(
//                         (status) => DropdownMenuItem(
//                           value: status,
//                           child: Text(status),
//                         ),
//                       )
//                       .toList(),
//               onChanged: (value) => selectedStatus = value ?? 'Paid',
//               decoration: const InputDecoration(labelText: 'Status'),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => handleAddPayment(context),
//                 child: const Text('Add Payment'),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Divider(),
//             const SizedBox(height: 12),
//             const Text(
//               'All Payments',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: Obx(
//                 () => ListView.builder(
//                   itemCount: controller.payments.length,
//                   itemBuilder: (context, index) {
//                     final payment = controller.payments[index];
//                     return Card(
//                       child: ListTile(
//                         title: Text('User: ${payment.user}'),
//                         subtitle: Text(
//                           'Amount: \$${payment.amount} | Date: ${payment.date.toLocal().toString().split(' ')[0]} | Status: ${payment.status}',
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit),
//                               onPressed:
//                                   () => showEditDialog(context, index, payment),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () => controller.deletePayment(index),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Payment Management Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
