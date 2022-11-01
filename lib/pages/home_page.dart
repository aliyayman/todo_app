import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage=locator<LocalStorage>();
    _allTasks=<Task>[];
    _getAllTaskFromDb();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet(context);
          },
          child: const Text('Bugün Neler Yapacaksın?',style: TextStyle(color: Colors.black),)),
        centerTitle: false,
        actions: [
          IconButton(onPressed: (){
            _showSearhPage();

          }, icon: const Icon(Icons.search)),
                 IconButton(onPressed: (){
                  _showAddTaskBottomSheet(context);

          }, icon: const Icon(Icons.add)),

        ],
        
      ),
      body:_allTasks.isNotEmpty?
       ListView.builder(itemBuilder: ((context, index) {
        var element = _allTasks[index];
        return Dismissible(
          background: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:const [
            Icon(Icons.delete,color: Colors.grey,),
            Text('Bu Görev Silindi')
          ]),
          key: Key(element.id),
          onDismissed: (direction) {
            _allTasks.removeAt(index);
            _localStorage.deleteTask(task: element);
            setState(() {
              
            });
          },
          child: TaskItem(task: element),
        );
      }
      ),itemCount: _allTasks.length,) : const Center(child: Text('Hadi Görev Ekle',style:TextStyle(fontSize: 24) ,),) ,
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        width: MediaQuery.of(context).size.width,
        child:  ListTile(

          title: TextField(
            autofocus: true,
              style:const TextStyle(fontSize: 20),
            decoration:const InputDecoration(
              hintText: 'Görev nedir?',
              border: InputBorder.none
            ),
            onSubmitted: (value) {
              Navigator.of(context).pop();
              if(value.length>3){
                 DatePicker.showTimePicker(context,showSecondsColumn: false,onConfirm: (time)async {
                   var newTask = Task.create(name: value, dateTime: time);
                   _allTasks.insert(0, newTask);
                   await  _localStorage.addTask(task: newTask);
                   setState(() {
                     
                   });
                 },);

              }
             
            },
          ),
        ),
      );
    },
    );
  }
  
  void _getAllTaskFromDb()async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {
      
    });
  }

  void _showSearhPage() async{
   await  showSearch(context: context, delegate: CustomSearhDelegate(allTasks: _allTasks));
   _getAllTaskFromDb();

  }
}