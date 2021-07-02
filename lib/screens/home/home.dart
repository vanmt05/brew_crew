import 'package:brew_crew/models/brew.models.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              color: Colors.grey[300],
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>?>.value(
      initialData: null,
      value: DatabaseService().brews,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: Text('Brew Crew'),
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                label: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.black),
                )),
            TextButton.icon(
              onPressed: _showSettingPanel,
              icon: Icon(Icons.person, color: Colors.black),
              label: Text('Setting', style: TextStyle(color: Colors.black)),
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/coffee_bg.png'), fit: BoxFit.cover),
            ),
            child: BrewList()),
      ),
    );
  }
}
