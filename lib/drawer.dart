import 'package:flutter/material.dart';
import 'todolist.dart';
import 'database.dart';
import 'main.dart';
import 'package:dotted_border/dotted_border.dart';

Future<Todolist> createAlertDialogForEntering(context, List<Todolist> list) {
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.only(left: 26.0, right: 26.0),
            child: Form(
              key: _formkey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Enter The Name of the List',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'This field should no be empty';
                      }
                      for (int i = 0; i < list.length; i++)
                        if (list[i].name.toLowerCase() == input.toLowerCase()) {
                          return 'Already Exists. Try a different name';
                        }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      MaterialButton(
                          child: Text('Add'),
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              Navigator.of(context).pop(Todolist(
                                name: nameController.text.toString(),
                              ));
                            }
                          }),
                      MaterialButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Widget viewMenu(context, List<Todolist> lists, Function setState) {
  List<Widget> list = List<Widget>.generate(lists.length, (index) {
    Todolist job = lists[index];
    return Card(
      child: ListTile(
        leading: Icon(Icons.view_list),
        title: Text(job.name),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            await DBProvider.db.deleteList(lists[index].name);
            print(colorList.length);
            colorList.removeAt(index);
            setState(() {
              if (currentIndex == index) {
                if (lists.length == 2)
                  currentIndex = 0;
                else if (index == lists.length - 1) currentIndex--;
              } else if (currentIndex == lists.length - 1) currentIndex--;
              l--;
            });
          },
        ),
        onTap: () => setState(() {
          currentIndex = index;
          Navigator.pop(context);
        }),
      ),
    );
  });

  list.insert(
      0,
      DrawerHeader(
        decoration: BoxDecoration(
            color: Colors.blue,
            gradient:
                RadialGradient(radius: 1, colors: [Colors.white, colorList[currentIndex]])),
        child: Center(
          child: Text('List of Your Lists'),
        ),
      ));

  GestureDetector gd = GestureDetector(
    child: Center(
      child: Icon(
        Icons.add_circle_outline,
        color: Colors.grey,
        size: 40,
      ),
    ),
    onTap: () async {
      await createAlertDialogForEntering(context, lists).then((value) async {
        if (value != null) {
          await DBProvider.db.createList(value.name);
          currentIndex = lists.length;
          l++;
          colorList.add(Colors.blue);
          setState(() {});
        }
      });
    },
  );

  list.add(Padding(
    padding: const EdgeInsets.all(8.0),
    child: DottedBorder(
      color: Colors.grey,
      strokeWidth: 1,
      child: gd,
    ),
  ));

  list.removeAt(1);
  return ListView(
    children: list,
  );
}
