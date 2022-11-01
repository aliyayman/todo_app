import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

final locator =GetIt.instance;
void setup(){
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive()async{
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');
  for (var task in taskBox.values) {
    if(task.dateTime.day != DateTime.now().day){
      taskBox.delete(task.id);
    }
  }

}
Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await setupHive();
  setup();
  runApp(const MyApp());

} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black)

        )
      ),
      home: HomePage()
    );
  }
}