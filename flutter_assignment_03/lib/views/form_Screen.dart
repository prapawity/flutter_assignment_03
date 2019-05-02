import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment_03/controller/controller.dart';

class form_screen extends StatelessWidget {
  FirebaseFirestoreService todo = new FirebaseFirestoreService();
  final myController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String title = "";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
        centerTitle: true,
      ),
      body: Container(
          child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: myController,
                      decoration:
                          InputDecoration(labelText: 'Enter your username'),
                          validator: (value){
                            if (value.isEmpty){
                              return 'Please Fill Subject';
                            }else{
                              title = value;
                            }
                          },
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      ),
                      color: Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: () {
                        _formkey.currentState.validate();
                        Firestore.instance.collection('todo').add({'title':title,'status':false});
                      },
                    ),
                  ),
                ],
              ))),
    );
  }
}
