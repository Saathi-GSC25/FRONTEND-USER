import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:saathi_user/components/report_screen/top_bar.dart';

class Interests extends StatefulWidget {
  final Map<String, dynamic> reportData;
  const Interests({super.key, required this.reportData});

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
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
                        duration: Duration(seconds: 2),
                        padding: EdgeInsets.all(16),
                        // height: MediaQuery.of(context).size.height * 0.09,
                        width: _isExpanded ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8,
                        height: _isExpanded ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF4B7B),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Interests",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    decoration: TextDecoration.none
                                  )
                                ),
                                GestureDetector(
                                  onTap: () => _hideOverlay(context),
                                  child: Icon(
                                    Icons.arrow_back, 
                                    color: Colors.white
                                  )
                                )
                              ]
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.reportData["interests_summary"].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
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
        margin: EdgeInsets.only(bottom: 8, left: 4, right: 8),
        padding: EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height * 0.09,
        decoration: BoxDecoration(
          color: Color(0xFFFF4B7B),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.arrow_outward, color: Colors.white)
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Interests",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                )
              )
            )
          ]
        )
      )
    );
  }
}