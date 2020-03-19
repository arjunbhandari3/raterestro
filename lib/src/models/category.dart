class Category {
  String id;
  String name;
  String image;

  Category();

  Category.fromJSON(Map<dynamic, dynamic> jsonMap)
      : id = jsonMap['id'].toString(),
        name = jsonMap['name'],
        image = jsonMap['image'];
}
