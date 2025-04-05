import 'package:flutter/material.dart';
import 'package:saathi_user/components/report_screen/top_bar.dart';

class ConversationReport extends StatefulWidget {
  final Map<String, dynamic> reportData;
  const ConversationReport({super.key, required this.reportData});

  @override
  State<ConversationReport> createState() => _ConversationReportState();
}

class _ConversationReportState extends State<ConversationReport> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder:(context) => Material(
        child: SafeArea(
        child: Column(
          children: [
            TopBar(),
            Container(
              padding: EdgeInsets.all(8),
              color: Color(0xFF9CD8FD),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Conversation Report",
                    style: TextStyle(
                      color: Color(0xFF0060FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: TextDecoration.none
                    )
                  ),
                  GestureDetector(
                    onTap: () => _hideOverlay(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF0060FF)
                    )
                  )
                ]
              )
            ),
            Expanded( child: Container(
              color: Color(0xFFC6E9FF),
              child: widget.reportData['conversationList'].isEmpty
              ? Center(
                  child: Text(
                    "No conversations yet",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 35,
                      color: Color(0xFF363636),
                    )
                  )
                ) 
              : ListView.builder(
                itemCount: widget.reportData['conversationList'].length,
                itemBuilder: (context, index) {
                  return ConversationCard(convInfo: widget.reportData['conversationList'][index]);
                },
              )
            ))
          ]
        ),
      )
    )
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOverlay(context),
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF9CD8FD),
          borderRadius: BorderRadius.circular(10)
        ),
        height: MediaQuery.of(context).size.height * 0.12,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.arrow_outward, color: Color(0xFF0060FF))
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Conversation Report",
                  style: TextStyle(
                    color: Color(0xFF0060FF),
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}

class ConversationCard extends StatelessWidget {
  final Map<String, dynamic> convInfo;

  const ConversationCard({super.key, required this.convInfo});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 18,
        color: Colors.black
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        color: Color(0xFFC6E9FF),
        child: Column(
          children: [
            Text(
              convInfo["date"],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF363636).withAlpha(192),
                fontWeight: FontWeight.bold
              )
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Color(0xFFB0B0B0))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time: ${convInfo["time"]}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(
                        'Time: ${convInfo["duration"]}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Summary:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(convInfo['summary'])
                      )
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Emotion: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(
                        convInfo['emotion'],
                      )
                    ]
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Stress Meter: ${convInfo['stress']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(convInfo['stressSummary'])
                      )
                    ]
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Interests:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(convInfo['interests'])
                      )
                    ]
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}