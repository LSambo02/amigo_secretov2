import 'dart:io';

import 'package:amigo_secretov2/widgets/loadingIndicator.dart';
import 'package:amigo_secretov2/widgets/secondaryButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/primaryButton.dart';
import 'pagesnavbar.dart';

class Addchild extends StatefulWidget {
  String docID;
  List childs;
  Addchild(this.docID, this.childs);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddChild(docID, childs);
  }
}

enum FormMode { LOGIN, SIGNUP }

class _AddChild extends State {
  String _docID;

  List _childs;
  _AddChild(this._docID, this._childs);
  final _formKey = new GlobalKey<FormState>();
  String nome, apelido, pass, pass1, email, nickname;
  File _image;
  CollectionReference utilizadores =
      Firestore.instance.collection("utilizadores");

  FirebaseUser currentUser;

  bool _isIos;
  bool _isLoading = false;
  String _errorMessage;
  String profileURL;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[_showLogo()],
          title: Text('Adicionar dependente'),
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
                  nameInput(),
                  apelidoInput(),
                  usernameInput(),
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
        validator: (value) => (value.isEmpty && value == pass)
            ? 'A password deve ser igual'
            : null,
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
        validator: (value) =>
            !(EmailValidator.validate(value)) ? 'Insira um email válido' : null,
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
            ? 'Password deve conter no mínimo 4 caracteres'
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
        uplpoadImage();
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
    File image;
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  uplpoadImage() async {
    File _img = File('../icon/icon.png');
    //print(_img.path.toString());
    //print(nome.toString() + "jssss");
    // print('im in');
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(nickname + '_profilePic' + '.jpg');
    StorageUploadTask task = _image != null
        ? firebaseStorageRef.putFile(_image)
        : firebaseStorageRef.putFile(_img);
    await (await task.onComplete).ref.getDownloadURL().then((value) {
      profileURL = value.toString();

      criar(value.toString());
    }).then((value) => CircularProgressIndicator());
  }

  void criar(String picURL) {
    List childs = new List();

    if (_childs.length != null)
      for (int i = 0; i < _childs.length; i++) {
        childs.add(_childs[i]);
      }

    utilizadores.document(_docID).get().then((DocumentSnapshot dS) {
      utilizadores
          .add({
            'username': nickname,
            'nome': nome,
            'apelido': apelido,
            'profile_picture': picURL,
            'dependencia': dS.data['username']
          })
          .then((result) => {
                childs.add(nickname),
                utilizadores.document(_docID).updateData({'childs': childs}),
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Pages();
                }))
              })
          .catchError((err) => print(err));
    });

    //print(pass);
  }
}
