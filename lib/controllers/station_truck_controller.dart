import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StationTruckController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var stations = <String>[].obs;
  var selectedStation = RxnString();
  var passCodes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStations();
  }

  void loadStations() {
    firestore.collection('station_truck').snapshots().listen((snapshot) {
      stations.value = snapshot.docs.map((doc) => doc.id).toList();

      if (selectedStation.value != null &&
          !stations.contains(selectedStation.value)) {
        selectedStation.value = null;
        passCodes.clear();
      }
    });
  }

  void onStationSelected(String stationId) async {
    selectedStation.value = stationId;
    final doc =
        await firestore.collection('station_truck').doc(stationId).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['pass_code'] != null) {
        passCodes.value = List<String>.from(data['pass_code']);
      } else {
        passCodes.clear();
      }
    }
  }

  Future<void> addStation(String name) async {
    if (name.trim().isEmpty) return;
    await firestore.collection('station_truck').doc(name).set({
      'pass_code': [],
    });
    selectedStation.value = name;
    passCodes.clear();
  }

  Future<void> addTruck(String truck) async {
    if (selectedStation.value == null || truck.trim().isEmpty) return;

    passCodes.add(truck);
    await firestore
        .collection('station_truck')
        .doc(selectedStation.value)
        .update({'pass_code': passCodes});
  }

  Future<void> deleteTruck(String truck) async {
    if (selectedStation.value == null) return;

    passCodes.remove(truck);
    await firestore
        .collection('station_truck')
        .doc(selectedStation.value)
        .update({'pass_code': passCodes});
  }

  Future<void> deleteStation(String stationName) async {
    await firestore.collection('station_truck').doc(stationName).delete();
    if (selectedStation.value == stationName) {
      selectedStation.value = null;
      passCodes.clear();
    }
  }

  Future<void> editTruck(int index, String newTruck) async {
    if (selectedStation.value == null || newTruck.trim().isEmpty) return;

    passCodes[index] = newTruck;
    await firestore
        .collection('station_truck')
        .doc(selectedStation.value)
        .update({'pass_code': passCodes});
  }
}
