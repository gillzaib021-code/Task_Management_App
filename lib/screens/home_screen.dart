import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    loadtaske();
  }

 //Loaded data
  loadtaske() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('tasks');

    if (data != null) {
      dynamic decoded = jsonDecode(data);

      if (decoded is List) {
        setState(() {
          tasks = decoded.map<Map<String, dynamic>>((e) {

            //  NEW (HANDLE BOTH OLD + NEW DATA)
            if (e is Map<String, dynamic>) {
              return e;
            } else if (e is String) {
              return {
                "title": e,
                "done": false,
              };
            }

            return {};
          }).toList();
        });
      }
    }
  }

  savetasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(tasks));
  }

  showAddDialouge() {
    final taskcontroller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 7, 64, 110),
        title: Text("Add Task", style: TextStyle(color: Colors.white)),
        content: TextFormField(
          style: TextStyle(color: Colors.white),
          controller: taskcontroller,
          decoration: InputDecoration(
            hintText: 'Enter your task',
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.white))),
          TextButton(
              onPressed: () {
                if (taskcontroller.text.isNotEmpty) {
                  setState(() {
                    tasks.add({
                      "title": taskcontroller.text,
                      "done": false
                    });
                  });
                  savetasks();
                }
                Navigator.pop(context);
              },
              child: Text("Add", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  //  FIXED (ADDED SAVE)
  toggletask(int index) {
    setState(() {
      tasks[index]["done"] = !tasks[index]["done"];
    });
    savetasks(); 
  }

  deleteindex(int index) {
    showDialog(
      
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:  const Color.fromARGB(255, 7, 64, 110),
        title: Text('Delete Task', style: TextStyle(color: Colors.white),),
        content: Text('Are you sure you want to delete it?', style: TextStyle(color: Colors.white),),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No', style: TextStyle(color: Colors.white),)),
          TextButton(
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
                savetasks();
                Navigator.pop(context);
              },
              child: Text('Yes', style:TextStyle(color: Colors.white),)),
        ],
      ),
    );
  }

  edittask(int index) {
    final editcontroller =
        TextEditingController(text: tasks[index]["title"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:  const Color.fromARGB(255, 7, 64, 110),
        title: Text('Edit Task', style: TextStyle(color: Colors.white),),
        content: TextFormField(controller: editcontroller,style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',style: TextStyle(color: Colors.white))),
          TextButton(
              onPressed: () {
                setState(() {
                  tasks[index]["title"] = editcontroller.text;
                });
                savetasks();
                Navigator.pop(context);
              },
              child: Text('Update',style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 7, 64, 110),
        centerTitle: true,
      ),
     body: tasks.isEmpty
    ? Center(child: Text('No Tasks Yet'))
    : ListView.separated(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Checkbox(
              value: tasks[index]["done"],
              onChanged: (_) => toggletask(index),
            ),
            title: Text(
              tasks[index]["title"],
              style: TextStyle(
                decoration: tasks[index]["done"]
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => edittask(index),
                  icon: Icon(Icons.edit,
                      color: Color.fromARGB(255, 7, 64, 110)),
                ),
                IconButton(
                  onPressed: () => deleteindex(index),
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(), // ✅ divider
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 7, 64, 110),
        onPressed: showAddDialouge,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}