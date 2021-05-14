import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  IO.Socket socket;

  TextEditingController _todoController = new TextEditingController();
  List todo = [];
  SharedPreferences prefs;
  String user = "";

  @override
  void initState() {
    super.initState();
    connectSocket();
    getPrefs();
  }

  void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void connectSocket() {
    try {
      socket =
          IO.io('https://test-todo-app-v1.herokuapp.com', <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });

      socket.connect();
      socket.onConnect((data) => print("Connected"));
      socket.emit('load-data', {});
      socket.on('data', (data) {
        setState(() {
          todo = data;
        });
      });
      socket.on('new-todo', (data) {
        todo.clear();
        print("Todo After Clear: " + todo.length.toString());
        setState(() {
          todo = data;
        });
        print(todo);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void addTodo(String todo) {
    socket.emit('add-todo', {"todo": todo, "user": prefs.getString("user")});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Todos",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                  ),
                ),
                Divider(),
                todo.length != 0
                    ? LimitedBox(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: todo.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.work),
                                title: Text(todo[index]["todo"]),
                                subtitle: Text(todo[index]["user"]),
                              );
                            }),
                      )
                    : Center(
                        child: Text(
                          "No Data",
                          style: TextStyle(
                            fontSize: 26,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Add Todo"),
                  content: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _todoController,
                          decoration: InputDecoration(
                            hintText: "Enter Todo",
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Add'),
                      onPressed: () {
                        print(_todoController.value.text.trim());
                        addTodo(_todoController.value.text.trim());
                      },
                    ),
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          size: 32,
        ),
      ),
    );
  }
}
