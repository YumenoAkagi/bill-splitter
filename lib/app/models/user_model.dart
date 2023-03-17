class UserModel {
  UserModel({
    required this.Id,
    required this.DisplayName,
    required this.Email,
    this.ProfilePicUrl,
  });

  String Id;
  String DisplayName;
  String Email;
  String? ProfilePicUrl;
}
