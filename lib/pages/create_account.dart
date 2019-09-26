import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pagesnavbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CriarUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CriarUser();
  }
}

enum FormMode { LOGIN, SIGNUP }

class _CriarUser extends State {
  final _formKey = new GlobalKey<FormState>();
  String nome, apelido, pass, pass1, email, nickname;
  File _image;
  CollectionReference utilizadores =
      Firestore.instance.collection("utilizadores");

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  FormMode _formMode = FormMode.SIGNUP;

  bool _isIos;
  bool _isLoading;
  String _errorMessage;
  String profileURL;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: _showLogo(),
          title: Text('Criar conta'),
        ),
        body: Container(
          margin: EdgeInsets.all(30.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _image == null
                      ? CircleAvatar(
                          radius: 80,
                          child: IconButton(
                            icon: Icon(Icons.photo),
                            tooltip: 'Adicionar foto',
                            onPressed: getImage,
                          ),
                        )
                      : CircleAvatar(
                          radius: 80,
                          child: ClipOval(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.file(
                                _image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                  _nomeInput(),
                  _apelidoInput(),
                  _nicknameInput(),
                  _emailInput(),
                  passwordInput(),
                  password1Input(),
                  _primaryButton(),
                  _secondaryButton()
                ],
              )),
        ));
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('icon/icon.png'),
        ),
      ),
    );
  }

  Widget _nomeInput() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        //controller: tFcontroller1,

        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Primeiro Nome',
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Nome não pode estar vazio' : null,
        onSaved: (value) => nome = value.trim(),
      ),
    );
  }

  Widget _apelidoInput() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        //controller: tFcontroller1,

        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Apelido',
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Apelido não pode estar vazio' : null,
        onSaved: (value) => apelido = value.trim(),
      ),
    );
  }

  Widget _nicknameInput() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        //controller: tFcontroller1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Nome de Utilizador',
            icon: Icon(
              Icons.account_circle,
              color: Colors.blueGrey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Nickname não pode estar vazio' : null,
        onSaved: (value) => nickname = value.trim(),
      ),
    );
  }

  Widget _emailInput() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        //controller: tFcontroller1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.email,
              color: Colors.blueGrey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Email não pode estar vazio' : null,
        onSaved: (value) => email = value.trim(),
      ),
    );
  }

  Widget passwordInput() {
    return new Padding(
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
        validator: (value) =>
            value.isEmpty ? 'Password não pode estar vazio' : null,
        onSaved: (value) => pass = value.trim(),
      ),
    );
  }

  Widget password1Input() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        //controller: tFcontroller1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Confirme a password',
            icon: Icon(
              Icons.lock,
              color: Colors.blueGrey,
            )),
        validator: (value) => value.isEmpty && identical(value, pass)
            ? 'A password deve ser igual'
            : null,
        onSaved: (value) => pass1 = value.trim(),
      ),
    );
  }

  Widget _secondaryButton() {
    return new FlatButton(
      child: new Text('Possui uma conta? Entre',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: () {
        setState(() {
          Navigator.pushReplacementNamed(context, '/login');
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
            child: new Text('Cadastrar',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        uplpoadImage();
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

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future getImage() async {
    File image;
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  uplpoadImage() async {
    File _img = File('icon/icon.png');
    //print(_img.path.toString());
    if (pass.length >= 6) {
      _criarWithmailPass(nickname, email, pass);
      _signInWithEmailPass(email, pass);
    }

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(nickname + '_profilePic' + '.jpg');
    StorageUploadTask task = _image != null
        ? firebaseStorageRef.putFile(_image)
        : firebaseStorageRef.putFile(_img);
    var imgURL = await (await task.onComplete).ref.getDownloadURL();

    profileURL = imgURL.toString();

    criar(imgURL.toString());
  }

  void criar(String picURL) {
    if (pass.length >= 6) {
      utilizadores
          .add({
            'username': nickname,
            'nome': nome,
            'apelido': apelido,
            'email': email,
            'profile_picture': picURL
          })
          .then((result) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Pages(currentUser);
                }))
              })
          .catchError((err) => print(err));

      //print(pass);
    }
  }

  void _criarWithmailPass(String username, String email, String pass) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: pass))
        .user;
    if (user != null) {
      FirebaseAuth.instance.currentUser().then((value) {
        UserUpdateInfo updateUser = UserUpdateInfo();
        updateUser.displayName = username;
        value.updateProfile(updateUser);
      });
      _signInWithEmailPass(email, pass);
      print(user.email);
      /**/
    }
  }

  Future<FirebaseUser> _signInWithEmailPass(String email, String pass) async {
    final FirebaseUser currentUser = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    ))
        .user;
    if (currentUser != null) return currentUser;
  }
}
