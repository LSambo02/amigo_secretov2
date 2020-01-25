import 'package:amigo_secretov2/pages/create_account.dart';
import 'package:amigo_secretov2/pages/login.dart';
import 'package:amigo_secretov2/pages/pagesnavbar.dart';
import 'package:amigo_secretov2/utilities/sharedPreferences.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(Page());
}

class Page extends StatelessWidget {
  SharedUserState userState = new UserState();
  StatefulWidget widg;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amigo Secreto',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // TODO: Handle this case.

              break;
            case ConnectionState.waiting:
              return CircularProgressIndicator();
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              //print(snapshot.data);
              return snapshot.data == false ? Login() : Pages();
              break;
          }
        },
        future: userState.read(),
      ),
      routes: {
        '/login': (context) => Login(),
        '/signup': (context) => CriarUser(),
        '/pages': (context) => Pages()
      },
    );
  }
}
