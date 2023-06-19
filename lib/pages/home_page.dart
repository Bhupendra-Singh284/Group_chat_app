import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/service/user_info.dart';

import 'auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String groupDescription = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(
                Icons.search,
              ))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Groups",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 150,
            color: Constants.primaryColor.withOpacity(1),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.group,
              size: 30,
            ),
            title: const Text(
              "Groups",
              style: TextStyle(color: Colors.black, fontSize: Constants.size1),
            ),
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(
                  context,
                  ProfilePage(
                    userName: userName,
                    email: email,
                  ));
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.person_sharp,
              size: 30,
            ),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black, fontSize: Constants.size1),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      titleTextStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      contentTextStyle:
                          const TextStyle(fontSize: 17, color: Colors.black),
                      content: const Text("Are you sure you want to logout?"),
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
                            )),
                        const SizedBox(
                          width: 2,
                        ),
                        TextButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Constants.primaryColor)),
                            child: const Text(
                              "Logout",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                        const SizedBox(
                          width: 8,
                        )
                        // IconButton(
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        //   icon: const Icon(
                        //     Icons.cancel,
                        //     color: Colors.red,
                        //   ),
                        // ),
                        // IconButton(
                        // onPressed: () async {
                        // await authService.signOut();
                        // Navigator.of(context).pushAndRemoveUntil(
                        //     MaterialPageRoute(
                        //         builder: (context) => const LoginPage()),
                        //     (route) => false);
                        // },
                        //   icon: const Icon(
                        //     Icons.done,
                        //     color: Colors.green,
                        //   ),
                        // ),
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.exit_to_app,
              size: 30,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: Constants.size1),
            ),
          )
        ],
      )),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
              ),
              titlePadding: const EdgeInsets.only(left: 15, top: 15),
              contentPadding: const EdgeInsets.all(15),
              actionsPadding: const EdgeInsets.only(bottom: 15, right: 15),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : const Text(
                          "Title",
                          style: TextStyle(
                              fontSize: 15.8,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    cursorColor: Constants.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        groupName = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 15.8,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    cursorColor: Constants.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        groupDescription = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(
                              userName,
                              FirebaseAuth.instance.currentUser!.uid,
                              groupName,
                              groupDescription)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context,
                          Constants.primaryColor.withOpacity(0.8),
                          "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text(
                    "CREATE",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              UserGroupInfo.userGroupCount = snapshot.data['groups'].length;
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
