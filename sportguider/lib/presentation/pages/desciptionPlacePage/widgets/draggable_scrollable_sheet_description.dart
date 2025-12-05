import "package:flutter/material.dart";

class DraggableScrollableSheetDescription extends StatefulWidget {
  @override
  State<DraggableScrollableSheetDescription> createState() =>
      _DraggableScrollableSheetDescriptionState();
}

class _DraggableScrollableSheetDescriptionState
    extends State<DraggableScrollableSheetDescription> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1.0,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text('Элемент списка $index'));
            },
          ),
        );
      },
    );
  }
}
