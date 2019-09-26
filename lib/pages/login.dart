import 'package:flutter/material.dart';
import './pagesnavbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

enum FormMode { LOGIN, SIGNUP }

class _Login extends State {
  FirebaseUser currentUser;
  final _formKey = new GlobalKey<FormState>();
  final tFcontroller = new TextEditingController();
  final tFcontroller1 = new TextEditingController();
  CollectionReference utilizadores =
      Firestore.instance.collection('utilizadores');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String pass;
  String email;

  bool _isIos;
  bool _isLoading;
  String _errorMessage;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 100.0),
        child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _showLogo(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: new InputDecoration(
                          hintText: 'Email',
                          icon: Icon(
                            Icons.mail,
                            color: Colors.blueGrey,
                          )),
                      /*validator: (value) =>
                            value.isEmpty ? 'Email deve ser Preenchido' : null,*/
                      onSaved: (value) => email = value.trim(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: TextFormField(
                      //controller: tFcontroller1,
                      obscureText: true,
                      autofocus: false,
                      decoration: new InputDecoration(
                          hintText: 'Password',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.blueGrey,
                          )),
                      /* validator: (value) => value.isEmpty
                            ? 'Password não pode estar vazio'
                            : null,*/
                      onSaved: (value) => pass = value.trim(),
                    ),
                  ),
                  _primaryButton(),
                  _secondaryButton()
                ],
              ),
            )),
      ),
    );
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('icon/icon.png'),
        ),
      ),
    );
  }

  Widget _secondaryButton() {
    return new FlatButton(
      child: new Text('Criar uma conta',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: () {
        setState(() {
          Navigator.pushReplacementNamed(context, '/signup');
        });
      },
    );
  }

  Widget _primaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blueGrey,
            child: new Text('Entrar',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        _signInWithEmailPass(email, pass);
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  Future<FirebaseUser> _signInWithEmailPass(String email, String pass) async {
    _getCurrentUser().then((user) async {
      if (user == null) {
        user = (await _auth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        ))
            .user;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Pages(user);
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Pages(user);
        }));
      }
    });
  }

  Future<FirebaseUser> _getCurrentUser() async {
    currentUser = await _auth.currentUser();
    return currentUser;
  }
}
