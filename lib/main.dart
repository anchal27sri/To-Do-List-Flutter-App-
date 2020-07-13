import 'package:flutter/material.dart';
import 'Item.dart';
import 'todolist.dart';
import 'database.dart';
import 'package:flutter/widgets.dart';
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
  int currentIndex;
  int listlen;
  int l;
  bool flag = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> choices = ['Blue', 'Red', 'Green', 'Yellow', 'Dark'];
  Map<String, Color> choiceColorMap = {
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Red': Colors.red,
    'Yellow': Colors.amber,
    'Dark': Colors.grey[600]
  };

  @override
  initState() {
    super.initState();
    currentIndex = -1;
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
                                    id: 0,
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
    List<Widget> list = List<Widget>();
    
    if (lists.length > 0) {
      List<Widget> temp = List<Widget>.generate(lists.length, (index) {
        Todolist job = lists[index];
        return Card(
          child: ListTile(
            leading: Icon(
              Icons.view_list,
              color: currentIndex == -1
                      ? Colors.blue
                      : choiceColorMap[lists[index].color],
            ),
            title: Text(job.name),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: currentIndex == -1
                      ? Colors.blue
                      : choiceColorMap[lists[index].color],
              ),
              onPressed: () async {
                await DBProvider.db
                    .deleteList(lists[index].name, lists[index].id);
                setState(() {
                  if (currentIndex == index) {
                    if (lists.length == 1)
                      currentIndex = -1;
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
      list.addAll(temp);
    }
    list.insert(
        0,
        DrawerHeader(
          decoration: BoxDecoration(
              color: Colors.blue,
              gradient: RadialGradient(radius: 1, colors: [
                Colors.white,
                lists.length == 0
                    ? Colors.blue
                    : currentIndex == -1
                        ? Colors.blue
                        : choiceColorMap[lists[currentIndex].color]
              ])),
          child: Center(
            child: Text('Your Lists',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.black),),
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
            await DBProvider.db.createList(value.name, lists.length + 1);
            l++;
            if (currentIndex == -1)
              currentIndex = 0;
            else
              currentIndex = lists.length;
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
              if (l == 0)
                currentIndex = -1;
              else
                currentIndex = 0;
              flag = false;
            }
            if (l == listsnapshot.data.length &&
                currentIndex < listsnapshot.data.length) {
              return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: currentIndex == -1
                      ? Text('No List')
                      : Text(listsnapshot.data[currentIndex].name),
                  backgroundColor: currentIndex == -1
                      ? Colors.blue
                      : choiceColorMap[listsnapshot.data[currentIndex].color],
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                  actions: currentIndex == -1
                      ? null
                      : <Widget>[
                          IconButton(
                            onPressed: () async {
                              await DBProvider.db.deleteAll(
                                  listsnapshot.data[currentIndex].name);
                              setState(() {});
                            },
                            icon: Icon(Icons.clear_all),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (choice) async {
                              listsnapshot.data[currentIndex].color = choice;
                              await DBProvider.db
                                  .updateList(listsnapshot.data[currentIndex]);
                              setState(() {});
                            },
                            itemBuilder: (BuildContext context) {
                              return choices.map((String choice) {
                                return PopupMenuItem<String>(
                                  height: 40,
                                  value: choice,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.color_lens,
                                        color: choiceColorMap[choice],
                                      ),
                                      Text(choice),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          )
                        ],
                ),
                drawer: Drawer(
                  child: viewMenu(context, listsnapshot.data, setState),
                ),
                body: currentIndex == -1
                    ? Center(child: Text('EMPTY'))
                    : FutureBuilder<List<Item>>(
                        future: DBProvider.db
                            .getAllItems(listsnapshot.data[currentIndex].name),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Item>> snapshot) {
                          if (snapshot.hasData) {
                            listlen = snapshot.data.length;
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
                                        // ll--;
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
                                              DBProvider.db.updateItem(
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
                                                  await DBProvider.db
                                                      .updateItem(
                                                          listsnapshot
                                                              .data[
                                                                  currentIndex]
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
                floatingActionButton: currentIndex == -1
                    ? null
                    : FloatingActionButton(
                        child: Icon(Icons.add),
                        backgroundColor: choiceColorMap[
                            listsnapshot.data[currentIndex].color],
                        onPressed: () {
                          createAlertDialogForEntering(context)
                              .then((value) async {
                            if (value != null) {
                              value.id = listlen;
                              await DBProvider.db.newItem(
                                  listsnapshot.data[currentIndex].name, value);
                              // ll++;
                              setState(() {});
                            }
                          });
                        }),
                floatingActionButtonLocation: currentIndex == -1
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
