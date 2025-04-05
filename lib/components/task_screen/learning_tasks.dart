import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saathi_user/components/task_screen/ltask_card.dart';
import 'package:saathi_user/components/task_screen/top_bar.dart';
import 'package:saathi_user/screens/task_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LearningTasks extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  const LearningTasks({super.key, required this.tasks});

  @override
  State<LearningTasks> createState() => _LearningTasksState();
}

class _LearningTasksState extends State<LearningTasks> {
  void onTap(BuildContext context) {}
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context, {Map<String, dynamic>? task}) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => _hideOverlay(context),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.black.withAlpha(125)),
                    ),
                  ),
                  Column(
                    children: [
                      TopBar(),
                      Expanded(
                        child: Center(
                          child: LTaskCard(
                            hideOverlay: _hideOverlay,
                            addTask: addTask,
                            updateTask: updateTask,
                            deleteTask: deleteTask,
                            task: task,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void addTask(String link, int points, String title) async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');
    if (sessionCookie == null) {
      return;
    }
    Map<String, dynamic> newTask = {
      'link': link,
      'is_done': false,
      'points': points,
      'title': title,
    };
    try {
      final response = await http.post(
        Uri.parse("http://35.200.160.97/common/learning/"),
        headers: {"Content-Type": "application/json", 'Cookie': sessionCookie},
        body: jsonEncode(newTask),
      );
      print(response.body);
      if (response.statusCode == 201) {
        setState(() {
          widget.tasks.add(Map<String, dynamic>.from(newTask));
        });
        _hideOverlay(
          context,
        ); // hide the overlay after successful task addition
      } else {
        print("Failed to add task: ${response.statusCode}");
        // Optionally show a snackbar or dialog
      }
    } catch (e) {
      print("Error while posting task: $e");
      // Optionally show a snackbar or dialog
    }
  }

  void updateTask(Map<String, dynamic> task) {
    for (int i = 0; i < widget.tasks.length; i++) {
      if (widget.tasks[i]['task_id'] == task['task_id']) {
        setState(() {
          widget.tasks[i] = task;
        });
      }
    }
  }

  void deleteTask(String taskId) {
    for (int i = 0; i < widget.tasks.length; i++) {
      if (widget.tasks[i]['task_id'] == taskId) {
        setState(() {
          widget.tasks.removeAt(i);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFFADDC1),
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Learning Tasks",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFF830A),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  GestureDetector(
                    onTap: () => _showOverlay(context),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFD1A4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.add_rounded, color: Color(0xFFFF830A)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              // padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                // color: Color(0xFFFFD1A4),
                color: Color(0xFFFADDC1),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  widget.tasks.isEmpty
                      ? Center(
                        child: Text(
                          "No tasks created yet",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 35,
                            color: Color(0xFF363636),
                          ),
                        ),
                      )
                      : DefaultTextStyle(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        child: SingleChildScrollView(
                          child: Table(
                            columnWidths: {
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                              2: IntrinsicColumnWidth(),
                            },
                            children:
                                widget.tasks.map<TableRow>((row) {
                                  return TableRow(
                                    decoration: BoxDecoration(
                                      color:
                                          row['is_done']
                                              ? Color(0xFFFFD1A4).withAlpha(125)
                                              : Color(0xFFFFD1A4),
                                    ),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8,
                                          top: 16,
                                          bottom: 16,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            launchUrl(
                                              Uri.parse(row['link']),
                                              mode:
                                                  LaunchMode
                                                      .externalApplication,
                                            );
                                          },
                                          child: Text(
                                            'Link',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 16,
                                        ),
                                        child: GestureDetector(
                                          onTap:
                                              () => _showOverlay(
                                                context,
                                                task: row,
                                              ),
                                          child: Text(row['title']),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                          top: 16,
                                          bottom: 16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.currency_bitcoin,
                                              color: Color(0xFFFF830A),
                                            ),
                                            Text('${row['points']}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
