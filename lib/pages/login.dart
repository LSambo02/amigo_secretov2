import 'package:amigo_secretov2/utilities/sharedPreferences.dart';
import 'package:amigo_secretov2/widgets/loadingIndicator.dart';
import 'package:amigo_secretov2/widgets/showAlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './pagesnavbar.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

enum FormMode { LOGIN, SIGNUP }

class _Login extends State {
  User currentUser;
  final _formKey = new GlobalKey<FormState>();
  final tFcontroller = new TextEditingController();
  final tFcontroller1 = new TextEditingController();
  CollectionReference utilizadores =
      FirebaseFirestore.instance.collection('utilizadores');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final SharedUserState userState = new UserState();

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
                  _isLoading ? LoadingIndicator() : _primaryButton(),
                  _secondaryButton(),
                  _forgetButton()
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

  Widget _forgetButton() {
    return new FlatButton(
      child: new Text('Esqueceu password? ',
          style: new TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w300,
              color: Colors.blueGrey)),
      onPressed: () {
        setState(() {
          _formKey.currentState.save();
          if (!email.isEmpty) {
            resetPassword(email);
            return ShowAlertDialog().showAlertDialog(
                context,
                'Verifique seu email',
                'Mandamos-lhe um email para reiniciar sua password \n Certifique-se de introduzir \n uma password que difere da anterior');
          } else {
            return ShowAlertDialog().showAlertDialog(
                context,
                'Verifique seu email e Password',
                'Insira pelo um email válido');
          }
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
      _isLoading = false;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        _signInWithEmailPass(email, pass);
        print('Signed in: $userId');
        setState(() {
          _isLoading = true;
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

  Future<User> _signInWithEmailPass(String email, String pass) async {
    print('pass');
    _getCurrentUser().then((user) async {
      if (user == null) {
        user = (await _auth
                .signInWithEmailAndPassword(
          email: email,
          password: pass,
        )
                .catchError((onError) {
          setState(() {
            _isLoading = false;
          });
          return ShowAlertDialog().showAlertDialog(
              context,
              "Email ou Password Incorrectos",
              "Por favor certifique-se \n de introduzir os dados correctos");
        }))
            .user;
        print(user);
        if (user.emailVerified) {
          userState.save(true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Pages();
          }));
        } else {
          _auth.signOut();
          userState.delete();
          setState(() {
            _isLoading = false;
          });
          return ShowAlertDialog().showAlertDialog(
              context,
              'Verifique seu email e Password',
              'Confirme seu endereço de email \n Mandamos-lhe um email de verficação');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _auth.signOut();
        userState.delete();
        return ShowAlertDialog().showAlertDialog(
            context, 'Verifique seu email e Password', 'Insira dados válidos');
      }
    });
  }

  Future<User> _getCurrentUser() async {
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
