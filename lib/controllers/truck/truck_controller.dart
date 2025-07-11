import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TruckController extends GetxController {
  var trucks = [].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTrucks();
  }

  void fetchTrucks() async {
    final snapshot = await _firestore.collection('trucks').get();
    trucks.value =
        snapshot.docs
            .map(
              (doc) => {
                'id': doc.id,
                'batteries': doc['batteries'],
                'capacity': doc['capacity'],
                'truckNumber': doc['truckNumber'],
              },
            )
            .toList();
  }

  Future<void> updateTruck(String id, Map<String, dynamic> data) async {
    await _firestore.collection('trucks').doc(id).update(data);
    fetchTrucks();
  }
}
