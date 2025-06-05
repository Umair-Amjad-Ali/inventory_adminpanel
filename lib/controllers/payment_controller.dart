import 'package:get/get.dart';
import 'package:inventory_adminpanel/constants/models/payment.dart';

class PaymentController extends GetxController {
  var payments = <Payment>[].obs;

  void addPayment(String user, double amount, DateTime date, String status) {
    payments.add(
      Payment(user: user, amount: amount, date: date, status: status),
    );
  }

  void editPayment(int index, Payment updatedPayment) {
    payments[index] = updatedPayment;
    payments.refresh();
  }

  void deletePayment(int index) {
    payments.removeAt(index);
  }
}
