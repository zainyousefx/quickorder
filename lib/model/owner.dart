class OwnerModel {
  int id;
  String name;
  String email;

  OwnerModel(this.id, this.name, this.email);

  factory OwnerModel.fromJson(json) =>
      OwnerModel(json['id'], json['name'], json['email']);

  toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}
