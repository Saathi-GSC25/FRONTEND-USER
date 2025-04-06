import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HTaskCard extends StatefulWidget {
  final Function(String from, String to, int points, String title) addTask;
  final Function(Map<String, dynamic> task) updateTask;
  final Function(String task_id) deleteTask;
  final Map<String, dynamic>? task;
  final Function hideOverlay;

  const HTaskCard({
    super.key,
    required this.hideOverlay,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    this.task,
  });

  @override
  State<HTaskCard> createState() => _HTaskCardState();
}

class _HTaskCardState extends State<HTaskCard> {
  late TextEditingController fromCtl, toCtl, pointCtl, titleCtl;

  @override
  void initState() {
    super.initState();
    fromCtl = TextEditingController(
      text: widget.task != null ? widget.task!['from'] : '',
    );
    toCtl = TextEditingController(
      text: widget.task != null ? widget.task!['to'] : '',
    );
    pointCtl = TextEditingController(
      text: widget.task != null ? '${widget.task!['points']}' : '',
    );
    titleCtl = TextEditingController(
      text: widget.task != null ? widget.task!['title'] : '',
    );
  }

  bool validate({bool add = false, bool edit = false, bool delete = false}) {
    String from = fromCtl.text.trim(), to = toCtl.text.trim();
    int points = int.tryParse(pointCtl.text) ?? 0;
    String title = titleCtl.text.trim();

    if (from.isNotEmpty && to.isNotEmpty && points != 0 && title.isNotEmpty) {
      if (add) {
        widget.addTask(from, to, points, title);
      } else if (edit) {
        widget.updateTask({
          'task_id': widget.task!['task_id'],
          'from_time': from,
          'to_time': to,
          'points': points,
          'title': title,
          'is_done': false,
        });
      }
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFADDC1),
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        spacing: 20,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Habitual Tasks",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFFF830A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time",
                        style: TextStyle(
                          color: Color(0xFFFF830A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFD1A4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextField(
                              controller: fromCtl,
                              decoration: InputDecoration(
                                hintText: "From",
                                border:
                                    InputBorder
                                        .none, // No border for the text field
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '-',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFD1A4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextField(
                              controller: toCtl,
                              decoration: InputDecoration(
                                hintText: "To",
                                border:
                                    InputBorder
                                        .none, // No border for the text field
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Points",
                        style: TextStyle(
                          color: Color(0xFFFF830A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFD1A4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: TextField(
                          controller: pointCtl,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            // hintText: "Ask anything",
                            border:
                                InputBorder
                                    .none, // No border for the text field
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(
                      color: Color(0xFFFF830A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD1A4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: titleCtl,
                      decoration: InputDecoration(
                        // hintText: "Ask anything",
                        border:
                            InputBorder.none, // No border for the text field
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap:
                      () => {
                        if (widget.task == null)
                          {
                            if (validate(add: true))
                              {widget.hideOverlay(context)},
                          }
                        else
                          {
                            if (validate(edit: true))
                              {widget.hideOverlay(context)},
                          },
                      },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF9CD8FD),
                    ),
                    child: Text(
                      widget.task != null ? "Update" : "Add",
                      style: TextStyle(
                        color: Color(0xFF0060FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (widget.task != null) {
                      widget.deleteTask(widget.task!['task_id']);
                    }
                    widget.hideOverlay(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFFF830A)),
                      // color: Color(0xFF9CD8FD)
                    ),
                    child: Text(
                      widget.task != null ? "Delete" : "Cancel",
                      style: TextStyle(
                        color: Color(0xFFFF830A),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
