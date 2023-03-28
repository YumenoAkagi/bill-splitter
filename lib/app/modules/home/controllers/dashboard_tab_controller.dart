import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';

class DashboardTabController extends GetxController {
  final strg = Get.find<GetStorage>();
  final userProvider = UserProvider();

  Rx<UserModel> userData = UserModel(
    Id: '',
    DisplayName: '',
    Email: '',
  ).obs;

  Future _getUserProfile() async {
    final userFromRepo = await userProvider.getUserProfile();
    userData.value = userFromRepo;
    print(userData.value);
    update();
  }

  void changeUserProfile(UserModel updatedProfile) {
    userData.value = updatedProfile;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _getUserProfile();
  }
}
