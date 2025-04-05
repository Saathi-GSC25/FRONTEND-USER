import 'package:flutter/material.dart';
import 'package:saathi_user/components/task_screen/habitual_tasks.dart';
import 'package:saathi_user/components/task_screen/learning_tasks.dart';
import 'package:saathi_user/components/task_screen/top_bar.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  Map<String, List<Map<String, dynamic>>> tasks = {
    "habitual": [
      {
        "task_id": "1",
        "from": "9:00", "to": "9:30", "points": 5,
        "title": "Morning Routine", "is_done": false,
      },
      {
        "task_id": "2",
        "from": "9:00", "to": "9:30", "points": 10,
        "title": "Prayer", "is_done": true
      },
      {
        "task_id": "3",
        "from": "17:00", "to": "18:30", "points": 20,
        "title": "Play Football", "is_done": true
      }
    ],
    "learning": [
      {
        "task_id": "1",
        "link": "https://www.youtube.com/watch?v=GLVhiScF3tI",
        "title": "Good Habits", "points": 20, "is_done": true
      }, 
      {
        "task_id": "2",
        "link": "https://www.youtube.com/watch?v=HsbbgwpHsug",
        "title": "Learn Public Manners", "points": 20, "is_done": false
      }
    ]
  };

  bool hasOverlay = false, htc = false, ltc = false;
  Map<String, dynamic>? task;

  void onTap(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 10,
          children: [
            TopBar(),
            HabitualTasks(tasks: tasks['habitual']!),
            LearningTasks(tasks: tasks['learning']!)
          ]
        )
      )
    );
  }
}
