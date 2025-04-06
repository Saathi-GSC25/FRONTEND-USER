import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:saathi_user/components/report_screen/top_bar.dart';

class StressMeterWidget extends StatefulWidget {
  final Map<String, dynamic> reportData;
  const StressMeterWidget({super.key, required this.reportData});

  @override
  State<StressMeterWidget> createState() => _StressMeterWidgetState();
}

class _StressMeterWidgetState extends State<StressMeterWidget> {
  final Map<String, List<Color>> stressColorMap = {
    "Stressless": [Color(0xFF5CFD87), Color(0xFF177630)],
    "High": [Color(0xFFF5C1C1), Color(0xFFEB4335)],
    "Low": [Color(0xFFFFE573), Color(0xFFE78906)],
    "Moderate": [Color(0xFFF9C593), Color(0xFFFF5A1C)]
  };

  OverlayEntry? _overlayEntry;
  bool _isExpanded = false;

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => _hideOverlay(context), 
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withAlpha(125)
                  )
                )
              ),
              Column(
                children: [
                  TopBar(),
                  Expanded(
                    child: Center(
                      child: AnimatedContainer(
                        duration: Duration(seconds: 10),
                        padding: EdgeInsets.all(16),
                        width: _isExpanded ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8,
                        height: _isExpanded ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          color: stressColorMap[widget.reportData["stress"]]?[0],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Stress Meter",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: stressColorMap[widget.reportData["stress"]]?[1],
                                    decoration: TextDecoration.none
                                  )
                                ),
                                GestureDetector(
                                  onTap: () => _hideOverlay(context),
                                  child: Icon(
                                    Icons.arrow_back, 
                                    color: stressColorMap[widget.reportData["stress"]]?[1]
                                  )
                                )
                              ]
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.reportData["stressSummary"].toString(),
                                  style: TextStyle(
                                    color: stressColorMap[widget.reportData["stress"]]?[1],
                                    fontSize: 24,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                              )
                            )
                          ]
                        )
                      )
                    )
                  )
                ]
              )
            ]
          )
        )
      )
    );

    Overlay.of(context).insert(_overlayEntry!);
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _isExpanded = true;
      });
    });
  }

  void _hideOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {
        _isExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOverlay(context),
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: stressColorMap[widget.reportData["stress"]]?[0],
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stress Meter",
                  style: TextStyle(
                    fontSize: 18,
                    color: stressColorMap[widget.reportData["stress"]]?[1]
                  )
                ),
                Icon(
                  Icons.arrow_outward, 
                  color: stressColorMap[widget.reportData["stress"]]?[1]
                )
              ]
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.reportData["stress"].toString(),
                  style: TextStyle(
                    color: stressColorMap[widget.reportData["stress"]]?[1],
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            )
          ]
        )
      )
    );
  }
}