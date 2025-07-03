import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:inventory_adminpanel/constants/models/user_model.dart';

class UserController extends GetxController {
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final Rxn<DocumentSnapshot> lastDocument = Rxn<DocumentSnapshot>();
  final int pageSize = 10;

  RxString sortBy = 'fullName'.obs;
  RxBool isDescending = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers(reset: true);
  }

  void fetchUsers({bool reset = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    if (reset) {
      lastDocument.value = null;
      users.clear();
    }

    Query query = FirebaseFirestore.instance
        .collection('users')
        .orderBy(sortBy.value, descending: isDescending.value)
        .limit(pageSize);

    if (lastDocument.value != null) {
      query = query.startAfterDocument(lastDocument.value!);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      lastDocument.value = snapshot.docs.last;
      users.addAll(
        snapshot.docs.map(
          (doc) =>
              UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        ),
      );
    }

    isLoading.value = false;
  }

  void updateUser(int index, UserModel updatedUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(updatedUser.id)
        .update(updatedUser.toMap());
    users[index] = updatedUser;
  }

  void deleteUser(int index) async {
    final user = users[index];
    await FirebaseFirestore.instance.collection('users').doc(user.id).delete();
    users.removeAt(index);
  }

  List<UserModel> get filteredUsers {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) return users;
    return users.where((user) {
      return user.fullName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.phoneNumber.contains(query);
    }).toList();
  }

  void changeSorting(String field) {
    if (sortBy.value == field) {
      isDescending.value = !isDescending.value;
    } else {
      sortBy.value = field;
      isDescending.value = false;
    }
    fetchUsers(reset: true);
  }
}

// Future<void> searchUsers(String query) async {
  //   if (query.isEmpty) {
  //     userSearchResults.clear();
  //     return;
  //   }

  //   final snapshot = await firestore.collection(usersCollection).get();

  //   userSearchResults.value =
  //       snapshot.docs
  //           .where((doc) {
  //             final data = doc.data();
  //             return data['email'].toString().toLowerCase().contains(
  //                   query.toLowerCase(),
  //                 ) ||
  //                 data['fullName'].toString().toLowerCase().contains(
  //                   query.toLowerCase(),
  //                 ) ||
  //                 data['phoneNumber'].toString().toLowerCase().contains(
  //                   query.toLowerCase(),
  //                 );
  //           })
  //           .map((doc) {
  //             final data = doc.data();
  //             data['uid'] = doc.id;
  //             return data;
  //           })
  //           .toList();
  // }