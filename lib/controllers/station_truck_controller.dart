import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../screens/station_truck_screen.dart';

class StationTruckController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var stations = <String>[].obs;
  var selectedStation = RxnString();
  var selectedUser = Rxn<Map<String, dynamic>>();
  var userSearchResults = <Map<String, dynamic>>[].obs;
  var passcodeController = ''.obs;
  var activeUsers = <Map<String, dynamic>>[].obs;

  final usersCollection = 'users';
  final passcodeCollection = 'truck_access_requests';

  @override
  void onInit() {
    super.onInit();
    loadStations();
    fetchActiveUsers();
  }

  void loadStations() {
    firestore.collection('station_truck').snapshots().listen((snapshot) {
      stations.value = snapshot.docs.map((doc) => doc.id).toList();
      if (selectedStation.value != null &&
          !stations.contains(selectedStation.value)) {
        selectedStation.value = null;
      }
    });
  }

  Future<void> addStation(String name) async {
    if (name.trim().isEmpty) return;
    await firestore.collection('station_truck').doc(name).set({});
    selectedStation.value = name;
  }

  Future<void> deleteStation(String name) async {
    await firestore.collection('station_truck').doc(name).delete();
    if (selectedStation.value == name) {
      selectedStation.value = null;
    }
    loadStations();
  }

  Future<void> searchUsersByText(String query) async {
    if (query.trim().isEmpty) {
      userSearchResults.clear();
      return;
    }

    final snapshot = await firestore.collection(usersCollection).get();

    userSearchResults.value =
        snapshot.docs
            .map((doc) => doc.data())
            .where(
              (user) =>
                  user['email'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  user['fullName'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  user['phoneNumber'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
  }

  void selectUser(Map<String, dynamic> user) {
    selectedUser.value = user;
    StationTruckScreen.searchController.text = user['email'];
    userSearchResults.clear();
  }

  String generateRandomPasscode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> assignPasscodeToUser() async {
    if (selectedUser.value == null ||
        selectedStation.value == null ||
        passcodeController.value.isEmpty) {
      return;
    }

    await firestore.collection(passcodeCollection).add({
      'uid': selectedUser.value!['uid'],
      'station': selectedStation.value,
      'passcode': passcodeController.value,
      'isUsed': false,
      'createdAt': Timestamp.now(),
    });

    passcodeController.value = '';
    selectedUser.value = null;
    StationTruckScreen.searchController.clear();
    fetchActiveUsers();
  }

  Future<void> fetchActiveUsers() async {
    final snapshot = await firestore.collection(passcodeCollection).get();

    final List<Map<String, dynamic>> enrichedUsers = [];

    for (var doc in snapshot.docs) {
      final passcodeData = doc.data();
      final uid = passcodeData['uid'];

      final userSnap =
          await firestore.collection(usersCollection).doc(uid).get();
      final userData = userSnap.data();

      enrichedUsers.add({
        ...passcodeData,
        'docId': doc.id,
        'email': userData?['email'] ?? '',
        'fullName': userData?['fullName'] ?? '',
      });
    }

    activeUsers.value = enrichedUsers;
  }

  Future<void> logoutUser(String docId) async {
    await firestore.collection(passcodeCollection).doc(docId).delete();
    fetchActiveUsers();
  }
}
