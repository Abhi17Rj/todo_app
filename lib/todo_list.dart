import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  var _auth;
  FirebaseFirestore _firestore;
  String taskAdd;
  void createAuth() async{
    _firestore = FirebaseFirestore.instance;
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createAuth();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bg.png'),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                     color: Colors.black.withOpacity(0.4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('TO-DO List', style: TextStyle(fontSize: 22.0),),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          await _auth.signOut();
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Icon(Icons.exit_to_app, size: 30.0,),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('task').snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData){
                          return Center(
                            child:  CircularProgressIndicator(
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                          );
                        }
                        final tasks = snapshot.data.docs;
                        List<Widget> taskWidgets = [];
                        for(var tsk in tasks){
                          var delId = tsk.id;
                          final taskName = tsk.data()['taskname'];

                          final taskWidget = TaskMessage(task: taskName, function: () async {
                            await FirebaseFirestore.instance.collection('task').doc(delId).delete();
                          },);
                          taskWidgets.add(taskWidget);
                        }

                        return ListView(
                            children: taskWidgets,
                          )
                        ;
                      },
                    ),
                    ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      Expanded(child: Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: TextField(
                          onChanged: (value) {
                            taskAdd = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            filled: false,
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      GestureDetector(
                        onTap: (){
                          _firestore.collection('task').add({
                            'taskname' : taskAdd,
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: 80.0,
                          child: Center(child: Text('ADD', style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

class TaskMessage extends StatefulWidget {
  final String task;
  var function;

  TaskMessage({@required this.task, this.function});

  @override
  _TaskMessageState createState() => _TaskMessageState();
}

class _TaskMessageState extends State<TaskMessage> {

  bool val = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Container(
            width: 40.0,
            child: Center(
              child: Checkbox(
                value: val,
                checkColor: Colors.white,
                activeColor: Colors.pinkAccent,
                onChanged: (ans){
                  setState(() {
                    setState(() {
                      val = ans;
                    });
                  });
                },
              ),
            ),
          ),
          Expanded(child: Container(
            child: Text(
              widget.task,
              style: TextStyle(
                fontFamily: 'Handlee',
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          )),
          Container(
            width: 40.0,
            child: Center(
              child: GestureDetector(
                onTap: widget.function,
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 23.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

