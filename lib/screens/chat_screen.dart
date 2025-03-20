import 'package:flutter/material.dart';

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
      _getResponse();
    }
  }

  Future<void> _getResponse() async {
    // Simulate a delay for receiving the response
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      // Once response is received, replace the 3 dots with a response message
      messages.add({
        "type": "received",
        "text": "This is the response message!",
      });
      isWaitingForResponse = false; // Stop waiting for the response
    });
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
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(Icons.message, color: Color(0xFFFF5A1C)),
                ),
                // SizedBox(width: 20),
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
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      "Hello 👋\nHow can I help you?",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontFamily: "Inter", fontSize: 35, color: Colors.blueGrey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: messages.length + (isWaitingForResponse ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (isWaitingForResponse && index == messages.length) {
                        // Display grey bubble with 3 dots while waiting
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "• • •",
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                        );
                      }

                      bool isSent = messages[index]["type"] == "sent";
                      return Align(
                        alignment:
                            isSent ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSent
                                ? Color(0xFFFFD9B3)
                                : Color(0x4FFFD19D),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            messages[index]["text"]!,
                            style: TextStyle(color: Colors.black),
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
                border: Border.all(color: Colors.black), // Border around the entire row
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Ask anything",
                        border: InputBorder.none, // No border for the text field
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
