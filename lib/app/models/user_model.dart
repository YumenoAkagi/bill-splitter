class UserModel {
  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.profilePicUrl,
  });

  String id;
  String displayName;
  String email;
  String? profilePicUrl;
}
