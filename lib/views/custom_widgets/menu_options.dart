import 'package:flutter/material.dart';

class MenuOptions extends StatelessWidget {
  final Function(String) onSelected;

  MenuOptions(this.onSelected);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'kitchen_countertop',
          child: Text('New Kitchen Countertop'),
        ),
        const PopupMenuItem<String>(
          value: 'island',
          child: Text('New Island'),
        ),
        // const PopupMenuItem<String>(
        //   value: 'export',
        //   child: Text('Export to DXF'),
        // ),
      ],
    );
  }
}
