class Category{
  int id;
  String name;

  Category(this.id, this.name);

  factory Category.fromJson(json) => Category(
      json['id'],
      json['name'],
     );

  toJson() => {
    "id": id,
    "name": name,
  };
}
