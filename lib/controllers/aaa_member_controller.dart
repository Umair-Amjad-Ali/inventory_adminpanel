import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AaMemberController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> members = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> allUsers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    fetchMembers();
    fetchAllUsers();
    super.onInit();
  }

  void fetchMembers() {
    _firestore
        .collection('users')
        .where('isAAAMember', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          members.value =
              snapshot.docs
                  .map((doc) => {'id': doc.id, ...doc.data()})
                  .toList();
        });
  }

  void fetchAllUsers() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      allUsers.value =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }

  void searchUsers(String query) {
    searchQuery.value = query.toLowerCase();
    searchResults.value =
        allUsers.where((user) {
          final name = (user['fullName'] ?? '').toLowerCase();
          final email = (user['email'] ?? '').toLowerCase();
          return name.contains(query.toLowerCase()) ||
              email.contains(query.toLowerCase());
        }).toList();
  }

  Future<void> markAsAAAMember(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isAAAMember': true,
    });
  }

  Future<void> removeAAAMember(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isAAAMember': false,
    });
  }
}
