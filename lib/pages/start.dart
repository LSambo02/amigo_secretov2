import 'package:flutter/material.dart';
import 'package:amigo_secretov2/pages/create_account.dart';
import 'package:amigo_secretov2/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pagesnavbar.dart';

class Start extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Start();
  }
}

class _Start extends State {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser currentUser;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Entrar"),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 300.0),
          child: Center(
            child: Column(
              children: <Widget>[
                RaisedButton(
                    child: Text('Criar conta'),
                    onPressed: () {
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CriarUser();
                            }));
                      });
                    }),
                RaisedButton(
                    child: Text('Entrar'),
                    onPressed: () {
                      setState(() {
                        _getCurrentUser().then((user) {
                          if (user == null) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return Login();
                                }));
                          } else {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return Pages(user);
                                }));
                          }
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return Login();
                            }));
                      });
                    })
              ],
            ),
          ),
        ));
  }
//TODO: CREATE A _GETCURRENTUSER CLASS FOR ALL WIDGETS
  Future<FirebaseUser> _getCurrentUser() async {
    currentUser = await _auth.currentUser();
    //print('Hello ' + currentUser.displayName.toString());
    return currentUser;
  }
}
