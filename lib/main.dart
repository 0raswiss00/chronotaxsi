import 'package:flutter/material.dart';

void main() {
  runApp(const ChronoTaxsiApp());
}

class ChronoTaxsiApp extends StatelessWidget {
  const ChronoTaxsiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChronoTaxsi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChronoTaxsi'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Mirë se vini në ChronoTaxsi!\nPlatforma juaj globale e taksive.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
