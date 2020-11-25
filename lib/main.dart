import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:todoapp/Signup_page.dart';
import 'todo_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData.dark().copyWith(
        backgroundColor: Colors.black
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool spinner = false;
  String email;
  String pass;
  var val = false;
  var _auth;

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
              SizedBox(
                width: 250.0,
                child: ColorizeAnimatedTextKit(
                  speed: Duration(milliseconds: 400),
                    text: [
                      "TODO App",
                      "TODO App",
                    ],
                    repeatForever: true,
                    textStyle: TextStyle(
                        fontSize: 55.0,
                        fontFamily: "BigShoulders"
                    ),
                    colors: [
                      Colors.white,
                      Colors.white70,
                      Colors.pinkAccent,
                      Colors.blue,
                      Colors.greenAccent,
                      Colors.black,
                    ],
                    textAlign: TextAlign.center,
                    alignment: AlignmentDirectional.center,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                      email = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    filled: false,
                    fillColor: Colors.white.withOpacity(0.6),
                    hintText: ' Email',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    pass = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              /*Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: val,
                      checkColor: Colors.white,
                      activeColor: Colors.pinkAccent,
                      onChanged: (ans){
                        setState(() {
                          val = ans;
                        });
                        print(val);
                      },
                    ),
                    Text('Keep me Signed In')
                  ],
                ),
              ),*/
              GestureDetector(
                onTap: () async{
                  setState(() {
                    spinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: pass);
                    print(user);
                    if (user != null){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AppPage() ;
                      }));
                    }

                    setState(() {
                      spinner = false;
                    });
                  }
                  catch(e) {
                    print("Error is : ");
                    print(e);
                    setState(() {
                      spinner = false;
                    });
                    return alert(context, title: Text('Invalid Email or Password'));
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
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignupPage();
                  }));
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

