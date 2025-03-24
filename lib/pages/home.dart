import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedValue = 'Friends';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SegmentedButton<String>(
          segments: const <ButtonSegment<String>>[
            ButtonSegment(value: 'Friends', label: Text('Friends')),
            ButtonSegment(value: 'Following', label: Text('Following')),
            ButtonSegment(value: 'For You', label: Text('For You')),
          ],
          selected: {selectedValue},
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedValue = newSelection.first;
            });
          },
        ),
        centerTitle: true,
      ),
      body: Center(child: Text('Selected: $selectedValue')),
    );
  }
}
