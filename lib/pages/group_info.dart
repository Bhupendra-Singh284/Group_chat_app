import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String ownerName;
  final String groupDescription;
  const GroupInfo(
      {Key? key,
      required this.ownerName,
      required this.groupName,
      required this.groupDescription,
      required this.groupId})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  bool isAdmin(String r) {
    final a = r.split('_');
    if (a.last == "@admin") {
      return true;
    }
    return false;
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Group Info"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 23, vertical: 8),
                        title: const Text("Exit"),
                        content: const Text(
                          "Are you sure you want to exit the group? ",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        titleTextStyle: const TextStyle(
                            fontSize: 18.7,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        actionsPadding: const EdgeInsets.symmetric(
                            horizontal: 17, vertical: 5),
                        actions: [
                          TextButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Constants.primaryColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              DatabaseService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .toggleGroupJoin(
                                      widget.groupId,
                                      getName(widget.ownerName),
                                      widget.groupName)
                                  .whenComplete(() {
                                nextScreenReplace(context, const HomePage());
                              });
                            },
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Constants.primaryColor)),
                            child: const Text(
                              "Leave",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app)),
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              itemBuilder: (context) => [
                    const PopupMenuItem(child: Text("Promote users")),
                    const PopupMenuItem(child: Text("Demote users")),
                  ])
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.2,
              backgroundColor: Constants.primaryColor,
              child: Icon(
                Icons.groups,
                size: MediaQuery.of(context).size.width * 0.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.groupName,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            widget.groupDescription.isNotEmpty
                ? Text(
                    widget.groupDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 87, 86, 86),
                        fontWeight: FontWeight.w500),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: index == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data['members'].length == 1
                                    ? "1 Participant"
                                    : "${snapshot.data['members'].length} Participants",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 125, 124, 124)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    getName(snapshot.data['members'][index])
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getName(
                                        snapshot.data['members'][index])),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: const EdgeInsets.all(4),
                                        child: const Text(
                                          "Owner",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 251, 87, 75),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  ],
                                ),
                                subtitle: Text(
                                    getId(snapshot.data['members'][index])),
                              ),
                            ],
                          )
                        : isAdmin(snapshot.data['members'][index])
                            ? ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    getName(snapshot.data['members'][index])
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                    getName(snapshot.data['members'][index])),
                                subtitle: Text(
                                    getId(snapshot.data['members'][index])),
                              )
                            : ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    getName(snapshot.data['members'][index])
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                    getName(snapshot.data['members'][index])),
                                subtitle: Text(
                                    getId(snapshot.data['members'][index])),
                              ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }
}
