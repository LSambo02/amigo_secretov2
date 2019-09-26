import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amigo_secretov2/widgets/nome.dart';
import 'package:amigo_secretov2/widgets/descInput.dart';
import 'groups.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

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

  final tFcontroller = new TextEditingController();
  final tFcontroller1 = new TextEditingController();

  //final tFcontroller5 = new TextEditingController();

  File _image;
  String _uploadedFileURL;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot _document;

  //final _formKey = GlobalKey<FormState>();

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
                controller: tFcontroller,
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
                controller: tFcontroller1,
              ),
            ],
          ),
        ),
        floatingActionButton: _primaryButton());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tFcontroller.dispose();
    tFcontroller1.dispose();
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
        .child(tFcontroller.text + '_group_icon' + '.jpg');
    StorageUploadTask task = _image != null ? firebaseStorageRef.putFile(_image) : firebaseStorageRef.putFile(_img);
    var imgURL = await (await task.onComplete).ref.getDownloadURL();

    group_iconURL = imgURL.toString();

    criar(imgURL.toString());

    /*StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image)..events.listen((event) => print('EVENT ${event.type}'));
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });*/
  }

  Widget _primaryButton() {
    return new FloatingActionButton(
      child: Icon(Icons.arrow_forward),
      onPressed: () => uplpoadImage(),
    );
  }

  void criar(String imgURL) {
    //String admin;
    if (tFcontroller.text != '' &&
        tFcontroller1.text != '' &&
        tFcontroller1 != null &&
        tFcontroller != null) {
      _getCurrentUser().then((value) {
        grupos
            .add({
              'nome': tFcontroller.text,
              'descricao': tFcontroller1.text,
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
