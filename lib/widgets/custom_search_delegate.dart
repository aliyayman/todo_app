import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/task_list_item.dart';

class CustomSearhDelegate extends SearchDelegate{
  final List<Task> allTasks;

  CustomSearhDelegate({required this.allTasks});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query.isEmpty ? null : query= '';

      }, icon: Icon(Icons.clear))

    ];
 
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(Icons.arrow_back_ios,color: Colors.black,size: 24,));
  }

  @override
  Widget buildResults(BuildContext context) {

    List<Task> filteredList = allTasks.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
    
    return filteredList.length>0 ?  ListView.builder(itemBuilder: ((context, index) {
        var element = filteredList[index];
        return Dismissible(
          background: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:const [
            Icon(Icons.delete,color: Colors.grey,),
            Text('Bu Görev Silindi')
          ]),
          key: Key(element.id),
          onDismissed: (direction)async {
          filteredList.removeAt(index);
          await  locator<LocalStorage>().deleteTask(task: element);
    
          },
          child: TaskItem(task: element),
        );
      }
      ),itemCount: filteredList.length,) : Center(child: Text('Arama Sonucu Bulunamadı'),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();


  }

}