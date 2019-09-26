import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'groups.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  bool _isLoading;
  String _errorMessage;
  final _formKey = new GlobalKey<FormState>();

  _CriarGrupo(Map<String, String> this.participantes);

  CollectionReference grupos = Firestore.instance.collection('grupos');
  FirebaseUser currentUser;

  final nomeController = new TextEditingController();
  final descController = new TextEditingController();


  File _image;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> snapshots = grupos.snapshots();
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
                //controller: tFcontroller1,
                autofocus: false,
                decoration: new InputDecoration(
                    hintText: 'Nome do grupo',
                    icon: Icon(
                      Icons.group,
                      color: Colors.blueGrey,
                    )),
                controller: nomeController,
              ),
              TextField(
                //controller: tFcontroller1,
                autofocus: false,
                decoration: new InputDecoration(
                    hintText: 'Descrição do grupo',
                    icon: Icon(
                      Icons.description,
                      color: Colors.blueGrey,
                    )),
                maxLines: 3,
                controller: descController,
              ),
            ],
          ),
        ),
        floatingActionButton: _primaryButton());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nomeController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future getImage() async {
    var _img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = _img;
      print(_image.path);
    });
  }

  uplpoadImage() async {
    File _img = File('icon/icon.png');
    //print(_img.path.toString());
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(nomeController.text + '_group_icon' + '.jpg');
    StorageUploadTask task = _image != null
        ? firebaseStorageRef.putFile(_image)
        : firebaseStorageRef.putFile(_img);
    var imgURL = await (await task.onComplete).ref.getDownloadURL();

    group_iconURL = imgURL.toString();

    criar(imgURL.toString());
  }

  Widget _primaryButton() {
    return new FloatingActionButton(
      child: Icon(Icons.arrow_forward),
      onPressed: () => uplpoadImage(),
    );
  }

  void criar(String imgURL) {
    //String admin;
    if (nomeController.text != '' &&
        descController.text != '' &&
        descController != null &&
        nomeController != null) {
      _getCurrentUser().then((value) {
        grupos
            .add({
              'nome': nomeController.text,
              'descricao': descController.text,
              'participantes': participantes,
              'admnistrador': value,
              'icon': imgURL
            })
            .then((result) => {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Grupos();
                  }))
                })
            .catchError((err) => print(err));
      });
    }
  }

  Future<String> _getCurrentUser() async {
    currentUser = await _auth.currentUser();
    //print('Hello ' + currentUser.displayName.toString());
    String username = currentUser.displayName.toString();
    return username;
  }
}
