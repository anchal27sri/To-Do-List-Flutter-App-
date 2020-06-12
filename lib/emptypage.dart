import 'package:flutter/material.dart';
import 'drawer.dart';
import 'todolist.dart';

Widget emptyPage(context,List<Todolist> lists,Function setState) {
    return Scaffold(
      appBar: AppBar(title: Text('No List')),
      body: Center(child: Text('EMPTY!'),),
      drawer: viewMenu(context, lists, setState),
    ); 
}
