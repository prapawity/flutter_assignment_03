import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment_03/controller/controller.dart';

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FirstPageState();
  }
}

class FirstPageState extends State<FirstPage> {
  Firestore todo = Firestore.instance;
  Stream<QuerySnapshot> test =
      Firestore.instance.collection('todo').snapshots();
  int len1 = 0;
  int len2 = 0;
  int _state = 0;
  List<AsyncSnapshot<QuerySnapshot>> listFalse = [];
  List<AsyncSnapshot<QuerySnapshot>> listFalse2 = [];
  @override
  Widget build(BuildContext context) {
    final List list_button = <Widget>[
      IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/form_screen");
        },
      ),
      IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.black,
        ),
        onPressed: (){
          for(var i = 0;i<listFalse2.length;i++){
            Firestore.instance.collection('todo').document(listFalse2[i].data.documents.elementAt(i).documentID).delete();
          }
        },
      )
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: _state,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Todo",
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[list_button[_state]],
          ),
          backgroundColor: Colors.white,
          body: _state == 0
              ? Container(
                  color: Colors.red,
                  child: StreamBuilder(
                    stream: todo.collection("todo").snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshort) {
                      listFalse = [];
                      if (snapshort.hasData) {
                        for(var i = 0;i< snapshort.data.documents.length;i++){
                          if(snapshort.data.documents.elementAt(i).data['status'] == false){
                            listFalse.add(snapshort);
                          }
                        }
                        return ListView.builder(
                          itemCount: listFalse.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(listFalse[index].data.documents.elementAt(index).data['title']),
                              trailing: Checkbox(
                                onChanged: (bool value) {
                                  todo
                                      .collection('todo')
                                      .document(listFalse[index].data.documents
                                          .elementAt(index)
                                          .documentID)
                                      .setData({
                                    'title': listFalse[index].data.documents
                                        .elementAt(index)
                                        .data['title'],
                                    'status': true
                                  });
                                },
                                value: listFalse[index].data.documents
                                    .elementAt(index)
                                    .data['status'],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text("No Data"),
                        );
                      }
                    },
                  ))
              : Container(
                  color: Colors.pink,
                  child: StreamBuilder(
                    stream: todo.collection("todo").snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshort) {
                      listFalse2 = [];
                      if (snapshort.hasData) {
                        for(var i = 0;i< snapshort.data.documents.length;i++){
                          if(snapshort.data.documents.elementAt(i).data['status'] == true){
                            listFalse2.add(snapshort);
                          }
                        }
                        return ListView.builder(
                          itemCount: listFalse2.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(listFalse2[index].data.documents.elementAt(index).data['title']),
                              trailing: Checkbox(
                                onChanged: (bool value) {
                                  todo
                                      .collection('todo')
                                      .document(listFalse2[index].data.documents
                                          .elementAt(index)
                                          .documentID)
                                      .setData({
                                    'title': listFalse2[index].data.documents
                                        .elementAt(index)
                                        .data['title'],
                                    'status': value
                                  });
                                },
                                value: listFalse2[index].data.documents
                                    .elementAt(index)
                                    .data['status'],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text("No Data"),
                        );
                      }
                    },
                  ),
                ),
          bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.black))),
            child: BottomNavigationBar(
              fixedColor: Colors.red,
              currentIndex: _state,
              onTap: onTabTapped,
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: new Icon(Icons.format_list_bulleted),
                  title: Text("Task"),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: new Icon(Icons.done_all),
                  title: Text("Completed"),
                ),
              ],
            ),
          )),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _state = index;
    });
  }
}
