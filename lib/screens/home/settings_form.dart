import 'package:brew_crew/models/user.models.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SettingsFormState extends State<SettingsForm> {
  List<String> sugarLevel = ['0', '1', '2', '3', '4'];
  String? _currentName;
  int? _currentStrength;
  String? _currentSugar;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return StreamBuilder<UserData>(
        initialData: null,
        stream: DatabaseService(uid: user?.userid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userDataStream = (snapshot.data as UserData);

            return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Update your brew settings'),
                    SizedBox(
                      height: 10.0,
                    ),
                    enterName(userDataStream),
                    SizedBox(
                      height: 30.0,
                    ),
                    sugar(userDataStream),
                    SizedBox(
                      height: 30.0,
                    ),
                    coffeeStrength(userDataStream),
                    SizedBox(
                      height: 30.0,
                    ),
                    updateButton(userDataStream, user)
                  ],
                ));
          } else {
            return Loading();
          }
        });
  }

  TextFormField enterName(userDataStream) {
    return TextFormField(
      initialValue: userDataStream.name,
      decoration: textInputDecoration,
      validator: (val) => val!.isEmpty ? 'Enter a name.' : null,
      onChanged: (val) => setState(() => _currentName = val),
    );
  }

  DropdownButtonFormField sugar(userDataStream) {
    return DropdownButtonFormField(
        value: (_currentSugar ?? userDataStream.sugar!),
        onChanged: (val) => setState(() => _currentSugar = val.toString()),
        items: sugarLevel.map((sugar) {
          return DropdownMenuItem(value: sugar, child: Text('$sugar sugars'));
        }).toList());
  }

  Slider coffeeStrength(userDataStream) {
    return Slider(
      value: (_currentStrength ?? userDataStream.strength!).toDouble(),
      min: 100.0,
      max: 900.0,
      divisions: 8,
      onChanged: (val) => setState(() => _currentStrength = val.round()),
      activeColor: Colors.brown[_currentStrength ?? userDataStream.strength!],
      inactiveColor: Colors.brown[_currentStrength ?? userDataStream.strength!],
    );
  }

  ElevatedButton updateButton(userDataStream, user) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await DatabaseService(uid: user?.userid).updateUserData(
              _currentSugar ?? userDataStream.sugar!,
              _currentName ?? userDataStream.name!,
              _currentStrength ?? userDataStream.strength!);
        }
      },
      child: Text('Update'),
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink)),
    );
  }
}
