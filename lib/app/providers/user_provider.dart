import '../models/user_model.dart';
import '../utils/app_constants.dart';
import '../utils/functions_helper.dart';

class UserProvider {
  Future getUserProfile() async {
    try {
      // ensure user is logged in when retriving profile
      final response = await supabaseClient.from('Users').select().match({
        'Id': supabaseClient.auth.currentUser!.id,
      }).maybeSingle() as Map;

      // insert user profile
      final userDataFromResponse = UserModel(
        Id: response['Id'],
        DisplayName: response['DisplayName'],
        Email: response['Email'],
        ProfilePicUrl: response['ProfilePictureURL'],
      );
      return userDataFromResponse;
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }
}
