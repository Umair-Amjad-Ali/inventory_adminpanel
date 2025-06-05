import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/models/battery.dart';

class BatteryController extends GetxController {
  final RxList<Battery> batteries = <Battery>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBatteries();
  }

  void fetchBatteries() async {
    final snapshot = await _firestore.collection('battery_data').get();
    batteries.value =
        snapshot.docs.map((doc) => Battery.fromJson(doc.data())).toList();
  }

  void addBattery(
    String number,
    double price,
    double discount,
    double deliveryCharges,
    double taxAndDisposalFees,
  ) async {
    final battery = Battery(
      number: number,
      price: price,
      discount: discount,
      deliveryCharges: deliveryCharges,
      taxAndDisposalFees: taxAndDisposalFees,
    );

    await _firestore.collection('battery_data').add(battery.toJson());
    batteries.add(battery);
  }

  void editBattery(int index, Battery updated) async {
    final docId =
        (await _firestore
                .collection('battery_data')
                .where('number', isEqualTo: batteries[index].number)
                .limit(1)
                .get())
            .docs
            .first
            .id;

    await _firestore
        .collection('battery_data')
        .doc(docId)
        .update(updated.toJson());
    batteries[index] = updated;
  }

  void deleteBattery(int index) async {
    final docId =
        (await _firestore
                .collection('battery_data')
                .where('number', isEqualTo: batteries[index].number)
                .limit(1)
                .get())
            .docs
            .first
            .id;

    await _firestore.collection('battery_data').doc(docId).delete();
    batteries.removeAt(index);
  }

  Map<String, dynamic> calculatePrice({
    required Battery battery,
    required int quantity,
  }) {
    double base = battery.price * quantity;
    double discountAmount = base * battery.discount / 100;
    double discounted = base - discountAmount;
    double total =
        discounted + battery.deliveryCharges + battery.taxAndDisposalFees;

    return {
      'basePrice': base,
      'discountAmount': discountAmount,
      'finalPrice': discounted,
      'deliveryCharges': battery.deliveryCharges,
      'taxAndDisposalFees': battery.taxAndDisposalFees,
      'total': total,
    };
  }
}
