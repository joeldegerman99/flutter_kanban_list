import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:card_list_view_drag/measure_size.dart';

class KanbanItem {
  final Widget child;
  KanbanItem({
    required this.child,
  });
}

class KanbanList {
  final List<KanbanItem> children;
  final Widget? header;
  KanbanList({
    required this.children,
    this.header,
  });
}

typedef OnItemReorder = void Function(
    int oldListIndex, int newListIndex, int oldItemIndex, int newItemIndex);

class KanbanListWidget extends StatefulWidget {
  KanbanListWidget({
    Key? key,
    required this.kanbanLists,
    this.listWidth,
    required this.onItemReorder,
    this.listColor,
    this.listBorderRadius,
  }) : super(key: key);

  final List<KanbanList> kanbanLists;
  final double? listWidth;
  final OnItemReorder onItemReorder;
  final Color? listColor;
  final BorderRadius? listBorderRadius;

  @override
  _KanbanListWidgetState createState() => _KanbanListWidgetState();
}

class _KanbanListWidgetState extends State<KanbanListWidget> {
  @override
  void initState() {
    super.initState();
  }

  Size itemSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    final listWidth =
        widget.listWidth ?? MediaQuery.of(context).size.width * .8;
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: constraints.maxHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.kanbanLists.map(
              (KanbanList list) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: widget.listColor,
                      borderRadius: widget.listBorderRadius),
                  width: listWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (list.header != null) list.header!,
                        ListView.builder(
                          itemCount: list.children.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = list.children[index];
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
                                        child: item.child,
                                      ),
                                    ),
                                    childWhenDragging: SizedBox(
                                      height: itemSize.height,
                                      child: Opacity(
                                        opacity: 0.5,
                                        child: item.child,
                                      ),
                                    ),
                                    child: item.child,
                                  ),
                                  DragTarget<KanbanItem>(onWillAccept: (data) {
                                    if (data != null &&
                                        list.children.indexOf(data) != index) {
                                      // print(true);
                                      return true;
                                    }

                                    return false;
                                  }, onAccept: (data) {
                                    final newListIndex =
                                        widget.kanbanLists.indexOf(list);
                                    final oldListIndex = widget.kanbanLists
                                        .indexWhere((element) => element
                                            .children
                                            .any((element) => element == data));
                                    final newIndex = index;
                                    final oldIndex = widget
                                        .kanbanLists[oldListIndex].children
                                        .indexOf(data);

                                    widget.onItemReorder(oldListIndex,
                                        newListIndex, oldIndex, newIndex);
                                  }, builder:
                                      (context, candidateData, rejectedData) {
                                    return Container(
                                      height: itemSize.height,
                                      width: double.infinity,
                                    );
                                  })
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
    );
  }
}
