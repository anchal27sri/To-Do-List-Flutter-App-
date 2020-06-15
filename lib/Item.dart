class Item {
  int id;
  int done;
  String title;
  String description;
  Item({this.done, this.title, this.description, this.id});

  Map<String, dynamic> toMap() => {
        "id": id,
        "done": done,
        "title": title,
        "description": description,
      };
}
