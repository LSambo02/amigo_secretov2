import 'dart:io';

import 'package:amigo_secretov2/widgets/loadingIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CriarGrupo extends StatefulWidget {
  Map<String, String> participantes;

  CriarGrupo(Map<String, String> this.participantes);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CriarGrupo(participantes);
  }
}

class _CriarGrupo extends State {
  Map<String, String> participantes;
  String nome, desc, group_iconURL;
  bool _isIos;
  bool _isLoading = false;
  String _errorMessage;
  final _formKey = new GlobalKey<FormState>();

  _CriarGrupo(Map<String, String> this.participantes);

  CollectionReference grupos = FirebaseFirestore.instance.collection('grupos');
  User currentUser;

  final nomeController = new TextEditingController();
  final descController = new TextEditingController();

  File _image;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criar grupo'),
        ),
        body: Container(
          margin: EdgeInsets.all(30.0),
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
              TextField(
                autofocus: false,
                decoration: new InputDecoration(
                    hintText: 'Nome do grupo',
                    icon: Icon(
                      Icons.group,
                      color: Colors.blueGrey,
                    )),
                controller: nomeController,
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                ),
                child: TextField(
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: 'Descrição do grupo',
                    icon: Icon(
                      Icons.description,
                      color: Colors.blueGrey,
                    ),
                  ),
                  maxLines: 3,
                  controller: descController,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton:
            _isLoading ? LoadingIndicator() : _primaryButton());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nomeController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future getImage() async {
    File _img = File(
        (await ImagePicker.platform.pickImage(source: ImageSource.gallery))
            .path);
    setState(() {
      _image = _img;
      //print(_image.path);
    });
  }

  uplpoadImage() async {
    DateTime now = DateTime.now();
    String dateNow = now.millisecondsSinceEpoch.toString();
    _getCurrentUser().then((value) {
      // print(value);
    });
    File _img = File('icon/icon.png');
    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(nomeController.text + '_group_icon' +dateNow+ '.jpg');
    UploadTask task = _image != null
        ? firebaseStorageRef.putFile(_image)
        : firebaseStorageRef.putFile(_img);
    var imgURL = await (await task.whenComplete(() {})).ref.getDownloadURL();

    group_iconURL = imgURL.toString();

    criar(imgURL.toString());
  }

  Widget _primaryButton() {
    return new FloatingActionButton(
      child: Icon(Icons.arrow_forward),
      onPressed: () {
        if (_image != null) {
          uplpoadImage();
          setState(() {
            _isLoading = true;
          });
        }
      },
    );
  }

  // update(value) => value = '';

  void criar(String imgURL) {
    if (nomeController.text != '' &&
        descController.text != '' &&
        descController != null &&
        nomeController != null) {
      _getCurrentUser().then((value) {
        //print(value + 'j');
        if (!participantes.containsKey(value)) participantes[value] = '';
        print(participantes);
        grupos.add({
          'nome': nomeController.text,
          'descricao': descController.text,
          'participantes': participantes,
          'admnistrador': value,
          'icon': imgURL
        }).then((result) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacementNamed(context, '/pages');
        }).catchError((err) => print(err));
      });
    }
  }

  Future<String> _getCurrentUser() async {
    currentUser = await _auth.currentUser;
    //print('Hello ' + currentUser.displayName.toString());
    String username = currentUser.displayName.toString();
    return username;
  }
}
