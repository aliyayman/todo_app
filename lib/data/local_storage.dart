import 'package:hive/hive.dart';
import 'package:todo_app/models/task_model.dart';

abstract class LocalStorage{
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage extends LocalStorage{
  late Box<Task> _taskBox;
  HiveLocalStorage(){
    _taskBox=Hive.box('tasks');
  }
  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
 
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask()async {
    List<Task> _allTasks=<Task>[];
    _allTasks = _taskBox.values.toList();
    if(_allTasks.isNotEmpty){
      _allTasks.sort((Task a, Task b) => b.dateTime.compareTo(a.dateTime));
      
    }
     return _allTasks;
    
  }

  @override
  Future<Task?> getTask({required String id})async {
    if(_taskBox.containsKey(id)){
      return _taskBox.get(id);
    }else{
      return null;
    }

  }

  @override
  Future<Task> updateTask({required Task task}) async{
   await task.save();
    return task;

  }

}

