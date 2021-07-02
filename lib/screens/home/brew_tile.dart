import 'package:brew_crew/models/brew.models.dart';
import 'package:flutter/material.dart';

class BrewTile extends StatelessWidget {
  final Brew? brew;
  BrewTile({this.brew});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 10.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.brown[brew!.strength],
            backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(brew!.name),
          subtitle: Text('Takes ${brew!.sugar} sugar(s)'),
        ),
      ),
    );
  }
}
