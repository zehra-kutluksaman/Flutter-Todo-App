import 'package:demo/view/homescreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/view_model/custombottom.dart'; // Eklendi

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();
  List<String> selectedDayTasks = [];

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      selectedDayTasks = []; // Seçilen günün görevlerini temizle
    });

    _getTasksForSelectedDay(day);
  }

  Future<void> _getTasksForSelectedDay(DateTime day) async {
    final selectedDayFormatted =
        "${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";

    final snapshot = await FirebaseFirestore.instance
        .collection("Todo")
        .where("Date", isEqualTo: selectedDayFormatted)
        .get();

    setState(() {
      selectedDayTasks =
          snapshot.docs.map((doc) => doc["Task"] as String).toList();
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Get.offAll(const HomeScreen());
    } else if (index == 1) {
      Get.to(const CalendarScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Takvim",
          style: TextStyle(
            fontSize: 28,
            color: Color.fromARGB(255, 241, 240, 240),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                onDaySelected: _onDaySelected,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedDayTasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "Görev Başlığı: ${selectedDayTasks[index]}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
