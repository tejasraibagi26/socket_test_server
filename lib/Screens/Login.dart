import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socketui/Screens/Todo.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userid = new TextEditingController();
  TextEditingController _pass = new TextEditingController();

  Socket socket;

  @override
  void initState() {
    super.initState();

    socket = io('https://test-todo-app-v1.herokuapp.com', <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.connect();
    socket.onConnect((data) => print("Connected"));
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", _userid.value.text.trim());
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Todos()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Todos using Sockets",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _userid,
                decoration: InputDecoration(
                  hintText: "User id",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _pass,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  login();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
