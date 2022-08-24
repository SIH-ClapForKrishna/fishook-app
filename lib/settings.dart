import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_ui_challenges/core/presentation/res/assets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart';

class SettingsPage extends StatefulWidget {
  static const String path = "lib/src/pages/settings/settings1.dart";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  static const String _title = 'Dashboard';
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var userId = "";
    if (user.phoneNumber == null)
      {
        userId = user.email as String;
      }
    else
      {
        userId = user.phoneNumber as String;
      }
    return Scaffold(
        //backgroundColor: const Color(0xff064273),
        appBar: AppBar(title: const Text(_title),),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //const SizedBox(height: 10.0),

                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: const Color(0xff064273),

                    child: ListTile(
                      onTap: () {
                        //open edit profile
                      },

                      leading: Text(
                        userId,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.lock_outline,
                            color: Color(0xff064273),
                          ),
                          title: const Text("Change Password"),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change password
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: const Icon(
                            FontAwesomeIcons.language,
                            color: Color(0xff064273),
                          ),
                          title: const Text("Change Language"),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change language
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: Color(0xff064273),
                          ),
                          title: const Text("Change Location"),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change location
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    "Notification Settings",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff064273),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SwitchListTile(
                    activeColor: const Color(0xff064273),
                    contentPadding: const EdgeInsets.all(0),
                    value: true,
                    title: const Text("Received notification"),
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      //backgroundColor: const Color(0xff064273),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 20),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      //color: Colors.grey.shade400,
    );
  }
}