import "package:flutter/material.dart";
import "package:sportguider/presentation/pages/desciptionPlacePage/widgets/draggable_scrollable_sheet_description.dart";

//если не работает, переделайте под StatefulWidget
class DescriptionPlacePage extends StatelessWidget {
  const DescriptionPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: DraggableScrollableSheetDescription());
  }
}
