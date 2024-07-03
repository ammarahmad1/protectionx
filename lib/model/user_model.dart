class UserModel {
  String? name;
  String? id;
  String? phone;
  String? childEmail;
  String? guardianEmail;
  String? guardianPhone;
  String? type;
  String? profilePic;

  UserModel(
      {this.name,
      this.childEmail,
      this.id,
      this.guardianEmail,
      this.guardianPhone,
      this.phone,
      this.profilePic,
      this.type});

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'id': id,
        'childEmail': childEmail,
        'guardiantEmail': guardianEmail,
        'guardianPhone': guardianPhone,
        'type': type,
        'profilePic': profilePic
      };
}