import 'package:flutter/material.dart';
import 'package:to_do_list/drawer.dart';
import 'Item.dart';
import 'todolist.dart';
import 'database.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

int currentIndex;
int l;
bool flag = true;
List<String> choices = <String>['Blue', 'Red', 'Yellow', 'Green', 'Dark'];
List<Color> colorList = List<Color>();

class _MyHomePageState extends State<MyHomePage> {
  Random random = new Random();

  @override
  initState() {
    super.initState();
    currentIndex = 1;
    flag = true;
    colorList.add(Colors.blue);
    colorList.add(Colors.blue);
  }

  Future<Item> createAlertDialogForEntering(context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                      'Enter Item',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Title"),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter the title of the task';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                            child: Text('Add Task'),
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                Navigator.of(context).pop(Item(
                                    id: random.nextInt(1000),
                                    done: 0,
                                    title: titleController.text.toString(),
                                    description:
                                        descriptionController.text.toString()));
                              }
                            }),
                        MaterialButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<Item> createAlertDialogForEditing(context, Item item) {
    TextEditingController titleController =
        TextEditingController(text: item.title);
    TextEditingController descriptionController =
        TextEditingController(text: item.description);
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                      'Edit details of the Item',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Title"),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter the title of the task';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                            // height: 20,
                            child: Text('Done'),
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                Navigator.of(context).pop(Item(
                                    done: 0,
                                    title: titleController.text.toString(),
                                    description:
                                        descriptionController.text.toString()));
                              }
                            }),
                        MaterialButton(
                            // height: 20,
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

  void choiceAction(String choice, List<Todolist> list) {}

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Todolist currentList = Todolist(name: "SampleList");
  int ll = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todolist>>(
        future: DBProvider.db.getAllTables(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Todolist>> listsnapshot) {
          if (listsnapshot.hasData) {
            if (flag) {
              l = listsnapshot.data.length;
              flag = false;
            }
            if (l == listsnapshot.data.length) {
              return Scaffold(
                key: _scaffoldKey,
                backgroundColor: (colorList[currentIndex] == Colors.grey[600])
                    ? Colors.grey[500]
                    : null,
                appBar: AppBar(
                  backgroundColor: colorList[currentIndex],
                  title: currentIndex == 0
                      ? Text('No List')
                      : Text(listsnapshot.data[currentIndex].name),
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () async {
                        await DBProvider.db
                            .deleteAll(listsnapshot.data[currentIndex].name);
                        setState(() {});
                      },
                      icon: Icon(Icons.clear_all),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (choice) {
                        if (choice == 'Blue') {
                          setState(() {
                            colorList[currentIndex] = Colors.blue;
                          });
                        } else if (choice == 'Red') {
                          setState(() {
                            colorList[currentIndex] = Colors.red;
                          });
                        } else if (choice == 'Yellow') {
                          setState(() {
                            colorList[currentIndex] = Colors.amber;
                          });
                        } else if (choice == 'Green') {
                          setState(() {
                            colorList[currentIndex] = Colors.green;
                          });
                        } else if (choice == 'Dark') {
                          setState(() {
                            colorList[currentIndex] = Colors.grey[600];
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return choices.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    )
                  ],
                ),
                drawer: Drawer(
                  child: viewMenu(context, listsnapshot.data, setState),
                ),
                body: currentIndex == 0
                    ? Center(child: Text('EMPTY'))
                    : FutureBuilder<List<Item>>(
                        future: DBProvider.db
                            .getAllItems(listsnapshot.data[currentIndex].name),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Item>> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, int index) {
                                  final item = snapshot.data[index];
                                  return Dismissible(
                                      key: UniqueKey(),
                                      onDismissed: (direction) async {
                                        await DBProvider.db.deleteItem(
                                            listsnapshot
                                                .data[currentIndex].name,
                                            item.id);
                                        ll--;
                                        snapshot.data.removeAt(index);
                                        setState(() {});
                                      },
                                      child: Card(
                                        elevation: 20.0,
                                        child: ListTile(
                                          leading: Checkbox(
                                            value: (item.done == 1),
                                            onChanged: (value) => setState(() {
                                              item.done = (value) ? 1 : 0;
                                              DBProvider.db.update(
                                                  listsnapshot
                                                      .data[currentIndex].name,
                                                  item);
                                            }),
                                          ),
                                          title: Text(
                                            item.title,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          subtitle: Text(
                                            item.description,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          // ],
                                          trailing: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              createAlertDialogForEditing(
                                                      context, item)
                                                  .then((value) async {
                                                if (value != null) {
                                                  item.title = value.title;
                                                  item.description =
                                                      value.description;
                                                  await DBProvider.db.update(
                                                      listsnapshot
                                                          .data[currentIndex]
                                                          .name,
                                                      item);
                                                  setState(() {});
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ));
                                });
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                floatingActionButton: currentIndex == 0
                    ? null
                    : FloatingActionButton(
                        child: Icon(Icons.add),
                        backgroundColor: colorList[currentIndex],
                        onPressed: () {
                          createAlertDialogForEntering(context)
                              .then((value) async {
                            if (value != null) {
                              await DBProvider.db.newItem(
                                  listsnapshot.data[currentIndex].name, value);
                              ll++;
                              setState(() {});
                            }
                          });
                        }),
                floatingActionButtonLocation: currentIndex == 0
                    ? null
                    : FloatingActionButtonLocation.endFloat,
                // persistentFooterButtons: <Widget>[
                //   MaterialButton(
                //     child: Text('Clear All'),
                //     onPressed: () async {
                // await DBProvider.db
                //     .deleteAll(listsnapshot.data[currentIndex].name);
                // setState(() {});
                //     },
                //   )
                // ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
