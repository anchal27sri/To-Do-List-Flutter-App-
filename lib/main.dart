import 'package:flutter/material.dart';
import 'Item.dart';
import 'todolist.dart';
import 'database.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  Random random = new Random();
  int currentIndex;
  int l;
  bool flag = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int ll = 0;

  @override
  initState() {
    super.initState();
    currentIndex = 1;
    flag = true;
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

  Future<Todolist> createAlertDialogForEnteringList(
      context, List<Todolist> list) {
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
                          if (list[i].name.toLowerCase() ==
                              input.toLowerCase()) {
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

  Widget emptyPage(context, List<Todolist> lists, Function setState) {
    return Scaffold(
      appBar: AppBar(title: Text('No List')),
      body: Center(
        child: Text('EMPTY!'),
      ),
      drawer: viewMenu(context, lists, setState),
    );
  }

  Widget viewMenu(context, List<Todolist> lists, Function setState) {
    List<Widget> list = List<Widget>.generate(lists.length, (index) {
      Todolist job = lists[index];
      return Card(
        child: ListTile(
          leading: Icon(
            Icons.view_list,
          ),
          title: Text(job.name),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () async {
              await DBProvider.db.deleteList(lists[index].name);
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
              gradient: RadialGradient(
                  radius: 1, colors: [Colors.white, Colors.blue])),
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
        await createAlertDialogForEnteringList(context, lists)
            .then((value) async {
          if (value != null) {
            await DBProvider.db.createList(value.name);
            currentIndex = lists.length;
            l++;
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
                appBar: AppBar(
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
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("$item dismissed"),
                                              Text("undo"),
                                            ],
                                          ),
                                        ));
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
