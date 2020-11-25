import 'package:flutter/material.dart';
import 'todo_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:alert_dialog/alert_dialog.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  var _auth;
  bool spinner = false;
  String email;
  String pass;
  void createAuth() async{
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
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                child: TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    filled: false,
                    fillColor: Colors.white.withOpacity(0.6),
                    hintText: 'Enter Email Id',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                child: TextField(
                  onChanged: (value) {
                    pass = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () async{
                    setState(() {
                      spinner = true;
                    });
                    try {
                      final user = await _auth.createUserWithEmailAndPassword(
                          email: email, password: pass);
                      if (user != null){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return AppPage() ;
                        }));
                      }

                      setState(() {
                        spinner = false;
                      });
                    } catch(e) {
                      print(e);
                      setState(() {
                        spinner = false;
                      });
                      return alert(context, title: Text('Incorrect Email or Password is weak / less than 6 characters'));
                    }
                  },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  width: double.infinity,
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
