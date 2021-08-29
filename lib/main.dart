import 'package:card_list_view_drag/kanban.dart';
import 'package:card_list_view_drag/test.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<KanbanList> kanbanList;

  @override
  void initState() {
    kanbanList = [
      KanbanList(
        children: [
          KanbanItem(
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Item 1'),
                ),
              ),
            ),
          ),
          KanbanItem(
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Item 2'),
                ),
              ),
            ),
          ),
          KanbanItem(
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Item 3'),
                ),
              ),
            ),
          ),
        ],
        header: buildHeader('Title 1'),
      ),
      KanbanList(
        children: [
          KanbanItem(
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Item 1'),
                ),
              ),
            ),
          ),
        ],
        header: buildHeader('Title 2'),
      ),
      KanbanList(
        children: [
          KanbanItem(
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Item 1'),
                ),
              ),
            ),
          ),
        ],
        header: buildHeader('Title 3'),
      ),
    ];
    super.initState();
  }

  Container buildHeader(String title) {
    return Container(
      height: 60,
      width: double.infinity,
      child: Card(
        color: Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return DragHandleExample();
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(),
      body: KanbanListWidget(
        listColor: Colors.blueGrey,
        kanbanLists: kanbanList,
        listBorderRadius: BorderRadius.circular(8),
        onItemReorder:
            (oldListIndex, newListIndex, oldItemIndex, newItemIndex) {},
      ),
    );
  }
}
