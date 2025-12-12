import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/binding/local_preferences.dart';
import '/core/constants/constants.dart';
import '/view/auth/login.dart';
import '/view/widgets/background.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  LocalPreferences localPreferences = Get.find();

  @override
  Widget build(BuildContext context) {
    var user = localPreferences.getUser()!.value;

    return Scaffold(
      body: BackGround(
        widget: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("My Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: mainColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                          leading: Icon(Icons.person,
                            color: mainColor,
                          ),
                          title: Text(user.name!,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      Divider(),
                      //--------
                      ListTile(
                          leading: Icon(
                            Icons.email_outlined,
                            color: mainColor,
                          ),
                          title: Text(user.email),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      Divider(),
                      //--------
                      ListTile(
                          onTap: () {
                            localPreferences.setUser(null);
                            Get.off(() => Login());
                          },
                          leading: Icon(
                            Icons.logout_outlined,
                            color: mainColor,
                          ),
                          title: Text("Sign out"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
