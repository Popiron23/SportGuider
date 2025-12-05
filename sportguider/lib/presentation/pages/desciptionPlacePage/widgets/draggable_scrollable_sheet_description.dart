import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:sportguider/presentation/pages/desciptionPlacePage/widgets/grabber.dart';

class DraggableScrollableSheetDescription extends StatefulWidget {
  @override
  State<DraggableScrollableSheetDescription> createState() =>
      _DraggableScrollableSheetDescriptionState();
}

class _DraggableScrollableSheetDescriptionState
    extends State<DraggableScrollableSheetDescription> {
  double _sheetPosition = 0.3;
  final double _dragSensitivity = 600;
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

          child: Column(
            children: <Widget>[
              Grabber(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _sheetPosition -= details.delta.dy / _dragSensitivity;
                    if (_sheetPosition < 0.25) {
                      _sheetPosition = 0.25;
                    }
                    if (_sheetPosition > 1.0) {
                      _sheetPosition = 1.0;
                    }
                  });
                },
              ),
              Flexible(
                child: Column(
                  children: [
                    Image.asset('assets/images/arsenal_new.jpg'),
                    Text(
                      'Стадион Арсенал. На стадионе есть стенка для оттачивания ударов в большом теннисе\nдва платных открытых корта для большого тенниса,\nплощадка для минифутбола(только секционная), четыре беговые полосы. ',
                    ),
                    Text('2-я Краснодраская ул., 145/6, 344091'),
                    Text('+7(863)207-52-08\nсш12.рф'),
                    Text('Ежедневно 7:00 - 21:00'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
