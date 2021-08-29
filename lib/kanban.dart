import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:card_list_view_drag/measure_size.dart';

class KanbanItem {
  final String title;
  KanbanItem({
    required this.title,
  });

  KanbanItem copyWith({
    String? title,
  }) {
    return KanbanItem(
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }

  factory KanbanItem.fromMap(Map<String, dynamic> map) {
    return KanbanItem(
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory KanbanItem.fromJson(String source) =>
      KanbanItem.fromMap(json.decode(source));

  @override
  String toString() => 'KanbanItem(title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KanbanItem && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}

class KanbanList {
  final List<KanbanItem> items;
  final String title;
  KanbanList({
    required this.items,
    required this.title,
  });

  KanbanList copyWith({
    List<KanbanItem>? items,
    String? title,
  }) {
    return KanbanList(
      items: items ?? this.items,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((x) => x.toMap()).toList(),
      'title': title,
    };
  }

  factory KanbanList.fromMap(Map<String, dynamic> map) {
    return KanbanList(
      items: List<KanbanItem>.from(
          map['items']?.map((x) => KanbanItem.fromMap(x))),
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory KanbanList.fromJson(String source) =>
      KanbanList.fromMap(json.decode(source));

  @override
  String toString() => 'KanbanList(items: $items, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KanbanList &&
        listEquals(other.items, items) &&
        other.title == title;
  }

  @override
  int get hashCode => items.hashCode ^ title.hashCode;
}

class KanbanListWidget extends StatefulWidget {
  const KanbanListWidget({Key? key}) : super(key: key);

  @override
  _KanbanListWidgetState createState() => _KanbanListWidgetState();
}

class _KanbanListWidgetState extends State<KanbanListWidget> {
  late List<KanbanList> kanbanList;

  @override
  void initState() {
    kanbanList = [
      KanbanList(
        items: [
          KanbanItem(title: 'List 0 index 0'),
          KanbanItem(title: 'List 0 index 1'),
          KanbanItem(title: 'List 0 index 2'),
        ],
        title: 'List 0',
      ),
      KanbanList(
        items: [
          KanbanItem(title: 'List 1 index 0'),
          KanbanItem(title: 'List 1 index 1'),
        ],
        title: 'List 1',
      ),
      KanbanList(
        items: [
          KanbanItem(title: 'List 2 index 0'),
          KanbanItem(title: 'List 2 index 1'),
          KanbanItem(title: 'List 2 index 2'),
        ],
        title: 'List 2',
      ),
    ];
    super.initState();
  }

  Size itemSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    final listWidth = MediaQuery.of(context).size.width * .8;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Kanban'),
      ),
      backgroundColor: Colors.blueGrey,
      body: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: kanbanList.map(
                (KanbanList list) {
                  return Container(
                    width: listWidth,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            color: Colors.greenAccent,
                            child: ListTile(
                              title: Text(list.title),
                            ),
                          ),
                          ListView.builder(
                            itemCount: list.items.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final item = list.items[index];
                              return MeasureSize(
                                onSizeChange: (size) {
                                  if (size == null) return;
                                  itemSize = size;
                                  setState(() {});
                                },
                                child: Stack(
                                  children: [
                                    Draggable<KanbanItem>(
                                      data: item,
                                      feedback: Transform.rotate(
                                        angle: -0.1,
                                        child: SizedBox(
                                          width: listWidth,
                                          height: itemSize.height,
                                          child: Card(
                                            child: ListTile(
                                              title: Text(item.title),
                                            ),
                                          ),
                                        ),
                                      ),
                                      childWhenDragging: SizedBox(
                                        height: itemSize.height,
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Card(
                                              child: ListTile(
                                            title: Text(item.title),
                                          )),
                                        ),
                                      ),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(item.title),
                                        ),
                                      ),
                                    ),
                                    DragTarget<KanbanItem>(
                                      onWillAccept: (data) {
                                        if (data != null &&
                                            list.items.indexOf(data) != index) {
                                          // print(true);
                                          return true;
                                        }

                                        return false;
                                      },
                                      onAccept: (data) {
                                        setState(() {
                                          final newListIndex =
                                              kanbanList.indexOf(list);
                                          final oldListIndex =
                                              kanbanList.indexWhere((element) =>
                                                  element.items.any((element) =>
                                                      element == data));
                                          final newIndex = index;
                                          final oldIndex =
                                              kanbanList[oldListIndex]
                                                  .items
                                                  .indexOf(data);

                                          kanbanList[oldListIndex]
                                              .items
                                              .removeAt(oldIndex);
                                          kanbanList[newListIndex]
                                              .items
                                              .insert(newIndex, data);

                                          // final listIndex =
                                          //     kanbanList.indexOf(list);
                                          // final oldIndex =
                                          //     list.items.indexOf(data);
                                          // final newIndex = index;

                                          // final kanban = KanbanList(
                                          //     items: list.items,
                                          //     title: list.title);

                                          // kanban.items.removeAt(oldIndex);
                                          // kanban.items.insert(newIndex, data);
                                          // // kanban.items
                                          // //     .insert(oldIndex, oldItem);
                                          // kanbanList.removeAt(listIndex);
                                          // kanbanList.insert(listIndex, kanban);
                                        });
                                      },
                                      builder: (context, candidateData,
                                          rejectedData) {
                                        // print(candidateData);
                                        // if (candidateData.isEmpty)
                                        return Container(
                                          height: itemSize.height,
                                          width: double.infinity,
                                        );

                                        return Column(
                                          children: [
                                            Container(
                                              height: itemSize.height,
                                            ),
                                            ...candidateData.map(
                                              (e) => Opacity(
                                                opacity: 0.5,
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(item.title),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
