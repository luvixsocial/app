import 'package:flutter/material.dart';
import 'package:luvixsocial/components/counter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: CounterButton()));
  }
}
