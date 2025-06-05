import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/battery_controller.dart';
import '../constants/models/battery.dart';

class BatteryScreen extends StatelessWidget {
  BatteryScreen({super.key});

  final BatteryController controller = Get.put(BatteryController());

  final TextEditingController numberController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController deliveryChargesController =
      TextEditingController();
  final TextEditingController taxController = TextEditingController();

  void handleAddBattery(BuildContext context) {
    final number = numberController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0;
    final discount = double.tryParse(discountController.text.trim()) ?? 0;
    final deliveryCharges =
        double.tryParse(deliveryChargesController.text.trim()) ?? 0;
    final tax = double.tryParse(taxController.text.trim()) ?? 0;

    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter battery number')),
      );
      return;
    }

    controller.addBattery(number, price, discount, deliveryCharges, tax);

    numberController.clear();
    priceController.clear();
    discountController.clear();
    deliveryChargesController.clear();
    taxController.clear();
  }

  void handleEditPopup(BuildContext context, int index, Battery battery) {
    final TextEditingController editNumber = TextEditingController(
      text: battery.number,
    );
    final TextEditingController editPrice = TextEditingController(
      text: battery.price.toString(),
    );
    final TextEditingController editDiscount = TextEditingController(
      text: battery.discount.toString(),
    );
    final TextEditingController editDelivery = TextEditingController(
      text: battery.deliveryCharges.toString(),
    );
    final TextEditingController editTax = TextEditingController(
      text: battery.taxAndDisposalFees.toString(),
    );
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Edit Battery',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _inputField(editNumber, 'Battery Number', bgColor),
                    _inputField(editPrice, 'Price', bgColor),
                    _inputField(editDiscount, 'Discount %', bgColor),
                    _inputField(editDelivery, 'Delivery Charges', bgColor),
                    _inputField(editTax, 'Tax & Disposal Fees', bgColor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            controller.editBattery(
                              index,
                              Battery(
                                number: editNumber.text,
                                price: double.tryParse(editPrice.text) ?? 0,
                                discount:
                                    double.tryParse(editDiscount.text) ?? 0,
                                deliveryCharges:
                                    double.tryParse(editDelivery.text) ?? 0,
                                taxAndDisposalFees:
                                    double.tryParse(editTax.text) ?? 0,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Add Battery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _inputField(numberController, 'Battery Number', bgColor),
            _inputField(priceController, 'Price', bgColor),
            _inputField(discountController, 'Discount %', bgColor),
            _inputField(deliveryChargesController, 'Delivery Charges', bgColor),
            _inputField(
              taxController,
              'Estimated Tax & Disposal Fees',
              bgColor,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => handleAddBattery(context),
                child: const Text('Add Battery'),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.batteries.length,
                  itemBuilder: (context, index) {
                    final battery = controller.batteries[index];
                    final result = controller.calculatePrice(
                      battery: battery,
                      quantity: 1,
                    );
                    return Card(
                      child: ListTile(
                        title: Text('Number: ${battery.number}'),
                        subtitle: Text(
                          'Price: \$${battery.price}, Discount: ${battery.discount}%, '
                          'Delivery: \$${battery.deliveryCharges}, Tax: \$${battery.taxAndDisposalFees}\n'
                          'Total: \$${result['total']}',
                        ),
                        trailing: Wrap(
                          spacing: 10,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed:
                                  () =>
                                      handleEditPopup(context, index, battery),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.deleteBattery(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String hint,
    Color bgColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          fillColor: bgColor,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}
