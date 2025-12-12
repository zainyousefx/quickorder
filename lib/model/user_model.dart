class UserModel {
  int? id;
  String? name;
  String email;
  int? type;
  String password;

  UserModel(this.id, this.name, this.email, this.type, this.password);

  UserModel.login(this.email, this.password);

  UserModel.register(this.name, this.email, this.type, this.password);

  factory UserModel.fromJson(json) => UserModel(json['id'], json['name'],
      json['email'], json['type_id'] ?? 1, json['password'] ?? "");

  toJson() => {
        "id": id,
        "name": name ?? "",
        "email": email,
        "type_id": type ?? "",
      };

  toRegisterJson() => {
        "name": name,
        "email": email,
        "type_id": type,
        "password": password,
      };

  toLoginJson() => {
        "email": email,
        "password": password,
      };
}
