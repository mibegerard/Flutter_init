import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Light Reaction Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TrafficLightPage(),
    );
  }
}

class TrafficLightPage extends StatefulWidget {
  const TrafficLightPage({Key? key}) : super(key: key);

  @override
  _TrafficLightPageState createState() => _TrafficLightPageState();
}

class _TrafficLightPageState extends State<TrafficLightPage> {
  Color _lightColor = Colors.red;
  bool _buttonEnabled = false;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(Duration(milliseconds: (5000 + DateTime.now().millisecond % 10000)), _changeColor);
  }

  void _changeColor() {
    setState(() {
      _lightColor = Colors.green;
      _startTime = DateTime.now();
      _buttonEnabled = true;
    });
  }

  void _calculateReactionTime() {
    if (_lightColor == Colors.green) {
      final DateTime endTime = DateTime.now();
      final Duration reactionTime = endTime.difference(_startTime);
      _showReactionDialog(reactionTime);
      setState(() {
        _lightColor = Colors.red;
        _buttonEnabled = false;
      });
      _startTimer();
    } else {
      _showErrorDialog();
    }
  }

  void _showReactionDialog(Duration reactionTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reaction Time'),
          content: Text('Your reaction time: ${reactionTime.inMilliseconds} ms'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Wait for the light to turn green before pressing the button!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Light Reaction Time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _lightColor,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buttonEnabled ? _calculateReactionTime : null,
              child: Text(_lightColor == Colors.green ? 'Press when light is green' : 'Wait for green light'),
            ),
          ],
        ),
      ),
    );
  }
}
