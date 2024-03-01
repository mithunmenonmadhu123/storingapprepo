import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> sendDataToBackend() async {
    final String task = _taskController.text;
    final DateTime dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    var response = await http.post(
      Uri.parse('http://10.0.2.2:3000/tasks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'task': task,
        'dateTime': dateTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      // Handle the response properly
      print('Data sent successfully');
    } else {
      // Handle the error
      print('Failed to send data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storing Application'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Enter the task and the time for the task to be completed!',
              style: TextStyle(color: Colors.blueAccent, fontSize: 30.0),
            ),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text('Select date and time'),
            ),
            Text(
              "Selected date: ${selectedDate.toLocal().toString().split(' ')[0]} \nSelected time: ${selectedTime.format(context)}",
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                  ),
                ),
                IconButton(
                  iconSize: 72,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    sendDataToBackend();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
