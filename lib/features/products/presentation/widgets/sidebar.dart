

import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Container(
width: 220,
color: Theme.of(context).colorScheme.surfaceVariant,
child: Column(
children: [
SizedBox(height: 24),
Padding(padding: const EdgeInsets.all(12.0), child: Text('Admin', style: Theme.of(context).textTheme.titleLarge)),
ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard')),
ListTile(leading: Icon(Icons.shopping_bag), title: Text('Products')),
ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
],
),
);
}
}