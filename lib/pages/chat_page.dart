import 'package:chat_app/pages/group_info.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/widgets/message_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String owner = "";
  String description = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        print("hello");
        chats = val;
      });
    });
    DatabaseService().getGroupOwner(widget.groupId).then((val) {
      setState(() {
        owner = val;
      });
    });
    DatabaseService().getGroupDescription(widget.groupId).then((val) {
      setState(() {
        description = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      groupDescription: description,
                      ownerName: owner,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // chat messages here
              const SizedBox(
                height: 20,
              ),

              chatMessages(),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                cursorColor: Colors.black,
                controller: messageController,
                style: const TextStyle(
                    color: Color.fromARGB(255, 65, 64, 64), fontSize: 17),
                decoration: const InputDecoration(
                  hintText: "Send a message...",
                  hintStyle: TextStyle(
                      color: Color.fromARGB(255, 55, 55, 55), fontSize: 17),
                  border: InputBorder.none,
                ),
              )),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  sendMessage();
                },
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 110, 85),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                      child: Icon(
                    Icons.send,
                    color: Colors.white,
                  )),
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return !snapshot.hasData
            ? Container()
            : snapshot.data.docs.length == 0
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3.2),
                    child: const Text(
                      "Start a new conversation by saying 'Hello' to everyone",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                          message: snapshot.data.docs[index]['message'],
                          sender: snapshot.data.docs[index]['sender'],
                          time: snapshot.data.docs[index]['time'],
                          sentByMe: widget.userName ==
                              snapshot.data.docs[index]['sender']);
                    },
                  );
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
