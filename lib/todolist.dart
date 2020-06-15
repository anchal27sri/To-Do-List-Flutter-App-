class Todolist {
  String name;
  String color;
  int id;
  Todolist({this.name,this.color,this.id});

   Map<String, dynamic> toMap()  {
     print('mapping $id');
     return {
        "id": id,
        "name": name,
        "color": color,
      };
   }
}
