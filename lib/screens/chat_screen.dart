import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // _ChatScreenState createState() => _ChatScreenState();
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isWaitingForResponse = false;

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add({"type": "sent", "text": text});
        isWaitingForResponse = true;
      });
      _messageController.clear();
      _getResponse(text);
    }
  }

  Future<void> _getResponse(String latest) async {
    Map<String, dynamic> historyData = {
      "history":
          messages.map((entry) {
            return {
              "role": entry["type"] == "sent" ? "user" : "model",
              "parts": entry["text"],
            };
          }).toList(),
      "chat": latest,
    };

    final url = Uri.parse('${dotenv.env['BASE_URL']}/parent/text_chat');
    final headers = {'Content-Type': 'application/json'};

    try {
      // Convert historyData to JSON string
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(historyData),
      );

      // Step 3: Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the server returns a 200 OK response, parse the JSON response
        final responseData = jsonDecode(response.body);
        setState(() {
          messages.add({"type": "received", "text": responseData['text']});
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }

    // await Future.delayed(Duration(seconds: 3));

    isWaitingForResponse = false; // Stop waiting for the response
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Header
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFFFAD4C6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFBB59B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.message, color: Color(0xFFFF5A1C)),
                ),
                Text(
                  "Chat with Aasha",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5A1C),
                  ),
                ),
              ],
            ),
          ),

          // Chat Messages Section
          Expanded(
            child:
                messages.isEmpty
                    ? Center(
                      child: Text(
                        "Hello 👋\nHow can I help you?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 35,
                          color: Colors.blueGrey,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount:
                          messages.length + (isWaitingForResponse ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (isWaitingForResponse && index == messages.length) {
                          // Display grey bubble with 3 dots while waiting
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade500,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "• • •",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }

                        bool isSent = messages[index]["type"] == "sent";
                        return Align(
                          alignment:
                              isSent
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.9,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSent
                                      ? Color(0xFFFFD9B3)
                                      : Color(0x4FFFD19D),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                isSent
                                    ? Text(
                                      messages[index]["text"]!,
                                      style: TextStyle(color: Colors.black),
                                    )
                                    : MarkdownBody(
                                      data: messages[index]["text"]!,
                                      styleSheet: MarkdownStyleSheet(
                                        p: TextStyle(color: Colors.black),
                                      ),
                                    ),
                          ),
                        );
                      },
                    ),
          ),

          // Message Input Box
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ), // Border around the entire row
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Ask anything",
                        border:
                            InputBorder.none, // No border for the text field
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.send, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
