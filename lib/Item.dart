import 'dart:convert';

Item clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Item.fromMap(jsonData);
}

String clientToJson(Item data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Item {
  int id;
  int done;
  String title;
  String description;
  Item({this.done, this.title, this.description, this.id});

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"],
        done: json["done"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "done": done,
        "title": title,
        "description": description,
      };
}
