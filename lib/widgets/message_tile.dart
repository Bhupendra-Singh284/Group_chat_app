import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final int time;
  final bool sentByMe;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.time,
      required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String getTime(int secondsSinceEpoch) {
    String result = "";
    final split = DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch)
        .toString()
        .split(' ');
    final dateSplit = split[0].split('-');
    result += (int.parse(dateSplit[2]) - 0).toString();
    result += "/";
    result += (int.parse(dateSplit[1]) - 0).toString();
    result += "/";
    result += (int.parse(dateSplit[0]) - 2000).toString();
    result += ' ';
    final splitTime = split[1].split(':');
    result += splitTime[0];
    result += ':';
    result += splitTime[1];
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print("called message tile");
    return Container(
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      width: double.infinity,
      margin: EdgeInsets.only(
          left: widget.sentByMe ? 0 : 20,
          right: widget.sentByMe ? 20 : 0,
          top: 10),
      child: Container(
        margin: EdgeInsets.only(
            left: widget.sentByMe ? 150 : 0, right: widget.sentByMe ? 0 : 150),
        padding: const EdgeInsets.only(top: 12, bottom: 8, left: 12, right: 12),
        decoration: BoxDecoration(
            borderRadius: widget.sentByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: widget.sentByMe
                ? const Color.fromARGB(255, 254, 117, 90)
                : Colors.white),
        child: Stack(
          children: [
            widget.sentByMe
                ? const SizedBox(
                    height: 0,
                  )
                : Text(
                    "${widget.sender}                 ",
                    style: TextStyle(
                        fontSize: 14.4,
                        fontWeight: FontWeight.w500,
                        color: widget.sentByMe ? Colors.white : Colors.black,
                        letterSpacing: -0.2),
                  ),
            // const SizedBox(
            //   width: 10,
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            Padding(
              padding:
                  EdgeInsets.only(top: widget.sentByMe ? 0 : 18, bottom: 14),
              child: Text("${widget.message}              ",
                  style: TextStyle(
                      fontSize: 16.2,
                      color: widget.sentByMe ? Colors.white : Colors.black)),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Text("\n${getTime(widget.time)}",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: widget.sentByMe
                              ? const Color.fromARGB(255, 251, 220, 214)
                              : const Color.fromARGB(255, 135, 178,
                                  253))) // const Color.fromARGB(255, 126, 173, 254))),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
