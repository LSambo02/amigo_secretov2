import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String nome, apelido, username, email, password;
  int numero;
  CollectionReference utilizadores =
  FirebaseFirestore.instance.collection("utilizadores");

  User(this.nome, this.apelido, this.username, this.email, this.password,
      this.numero);

  criarConta() {
    utilizadores
        .add({
          'username': username,
          'nome': nome,
          'apelido': apelido,
          'password': password,
          'email': email,
          'numero': numero
        })
        .then((result) => {print('success')})
        .catchError((err) => print(err));
  }
}
