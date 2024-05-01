import 'package:flutter/material.dart';

class visualizationsPage extends StatefulWidget {

  const visualizationsPage({super.key});

  @override
  _visualizationsPage createState() => _visualizationsPage();
}

class _visualizationsPage extends State<visualizationsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visualizations')),
      body: const Center( child:Column(
          children: [Text('Graphs'), Text('Charts')]
      )
    ));
  }
}