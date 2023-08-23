import 'dart:io';

import 'package:amigo_secretov2/pages/login.dart';
import 'package:amigo_secretov2/pages/pagesnavbar.dart';
import 'package:amigo_secretov2/utilities/sharedPreferences.dart';
import 'package:amigo_secretov2/widgets/secondaryButton.dart';
import 'package:amigo_secretov2/widgets/showAlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/loadingIndicator.dart';
import '../widgets/primaryButton.dart';

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
  PickedFile _image;
  CollectionReference utilizadores =
      FirebaseFirestore.instance.collection("utilizadores");

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser;

  FormMode _formMode = FormMode.SIGNUP;

  bool _isIos;
  bool _isLoading = false;
  String _errorMessage;
  String profileURL;

  List childs = new List();

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
                                File(_image.path),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                  nameInput(),
                  apelidoInput(),
                  usernameInput(),
                  emailInput(),
                  passwordInput(),
                  password1Input(),
                  _isLoading
                      ? LoadingIndicator()
                      : PrimaryButton('Cadastrar', _validateAndSubmit),
                  SecondaryButton('Possui uma conta? Entre', '/login')
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
        validator: (value) =>
            value.isEmpty ? 'A password deve ser igual' : null,
        onSaved: (value) => pass1 = value.trim(),
      ),
    );
  }

  Widget nameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        obscureText: false,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Primeiro Nome",
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
            )),
        validator: (value) => value.isEmpty ? 'Insira um nome válido' : null,
        onSaved: (value) => nome = value.trim(),
      ),
    );
  }

  Widget apelidoInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        obscureText: false,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Apelido",
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
            )),
        validator: (value) => value.isEmpty ? 'Insira apelido válido' : null,
        onSaved: (value) => apelido = value.trim(),
      ),
    );
  }

  Widget usernameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        obscureText: false,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Nome de utilizador",
            icon: Icon(
              Icons.account_circle,
              color: Colors.blueGrey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Nome de utilizador não pode estar vazio' : null,
        onSaved: (value) => nickname = value.trim(),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        obscureText: false,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Email",
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
            )),
        validator: (value) => !value.contains('@') && !value.contains('.')
            ? 'Insira um email válido'
            : null,
        onSaved: (value) => email = value.trim(),
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Password",
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
            )),
        validator: (value) => value.length < 6
            ? 'Password deve conter no mínimo 6 caracteres'
            : null,
        onSaved: (value) => pass = value.trim(),
      ),
    );
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = false;
    });
    if (_validateAndSave()) {
      String userId = nickname;
      try {
        //uplpoadImage();
        _criarWithmailPass(nickname, email, pass);
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

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate() && pass == pass1 && _image != null) {
      form.save();
      return true;
    }
    return false;
  }

  Future getImage() async {
    PickedFile image;
    image = (await ImagePicker.platform.pickImage(source: ImageSource.gallery))
        as PickedFile;
    setState(() {
      _image = image;
    });
  }

  uplpoadImage() async {
    DateTime now = DateTime.now();
    String dateNow = now.millisecondsSinceEpoch.toString();
    File _img = File('icon/icon.png');
    //print(_img.path.toString());
    //print(nome.toString() + "jssss");
    //_criarWithmailPass(nickname, email, pass);
    //_signInWithEmailPass(email, pass);

    print('im in');
    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(nickname + '_profilePic' + dateNow + '.jpg');
    UploadTask task = _image != null
        ? firebaseStorageRef.putFile(File(_image.path))
        : firebaseStorageRef.putFile(_img);
    await (await task.whenComplete(() {}))
        .ref
        .getDownloadURL()
        .then((value) => criar(value.toString()));
  }

  void criar(String picURL) {
    utilizadores
        .add({
          'username': nickname,
          'nome': nome,
          'apelido': apelido,
          'email': email,
          'profile_picture': picURL,
          'childs': childs
        })
        .then((result) => {
              print(currentUser.toString() + " check"),
              FirebaseAuth.instance.currentUser.updatePhotoURL(picURL),
              currentUser.toString() != null
                  ? _signInWithEmailPass(email, pass)
                  : Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                      return Login();
                    }))
            })
        .catchError((err) => print(err));

    //print(pass);
  }

  Future<String> _criarWithmailPass(
      String username, String email, String pass) async {
    final User user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: pass))
        .user;

    if (user != null) {
      await user.sendEmailVerification().then((onValue) {
        user.emailVerified
            ? print(user.email)
            : ShowAlertDialog().showAlertDialog(
                context,
                'Verifique seu email e Password',
                'Verifique seu endereço de email \n Mandamos-lhe um email de verficação');
        uplpoadImage();
        FirebaseAuth.instance.currentUser.updateDisplayName(username);
        return user.uid;
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
        });
        user.delete();
        ShowAlertDialog().showAlertDialog(context, 'Email inválido',
            'Certifique-se de introduzir um email válido e que tenha acesso');
      });
    }
  }

  Future<User> _signInWithEmailPass(String email, String pass) async {
    final User currentUser = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    ))
        .user;
    if (currentUser != null) {
      UserState().save(true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Pages();
      }));
    }
  }
}
