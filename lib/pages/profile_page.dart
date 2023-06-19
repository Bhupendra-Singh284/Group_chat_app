import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/service/user_info.dart';

import '../shared/constants.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.email, required this.userName})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          const Icon(
            Icons.account_circle,
            size: 150,
            color: Constants.primaryColor,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.userName,
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
            onTap: () {
              nextScreen(context, const HomePage());
            },
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
            onTap: () {},
            selected: true,
            selectedColor: Theme.of(context).primaryColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.person,
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                          const SizedBox(
                            width: 2,
                          ),
                          TextButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (route) => false);
                              },
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Constants.primaryColor)),
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                          const SizedBox(
                            width: 8,
                          )
                        ]);
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
              style: TextStyle(color: Colors.black, fontSize: Constants.size1),
            ),
          )
        ],
      )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_box,
              size: 200,
              color: Constants.primaryColor,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 18)),
                Text(widget.userName, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 18)),
                Text(widget.email, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Groups Joined", style: TextStyle(fontSize: 18)),
                Text(UserGroupInfo.userGroupCount.toString(),
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
