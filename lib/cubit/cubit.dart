import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/cubit/states.dart';
import 'package:to_do_app/modules/Archived_tasks/Archived_tasks_screen.dart';
import 'package:to_do_app/modules/Done_tasks/Done_tasks_screen.dart';

import '../modules/new_tasks/new_tasks_scren.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(intialState());
  int currentIndex = 0;
  bool isBottomShow = false;
  IconData fbIcon = Icons.edit;
  late Database database;
  List<Map> Newtasks = [];
  List<Map> Donetasks = [];
  List<Map> Archivedtasks = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = ['New tasks', 'Done tasks', 'Archived tasks'];
  void changeState(int index) {
    currentIndex = index;
    emit(BottomNavChangeState());
  }

  void ChangeBottomShow({required bool BottomShow, required IconData icon}) {
    isBottomShow = BottomShow;
    fbIcon = icon;
    emit(ChangeIsBottmomShowState());
  }

  delete() async {
    await deleteDatabase('todo.db').then((value) => print('deleted'));
  }

  createDataBase() async {
    //openDatabase(path,on create ,on open ) function that within it , we create db and create table an open db
    await openDatabase('todo.db', version: 1, onCreate: (db, version) {
      print(
          'db is created and given me object of it is called db and version $version ');
      db
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) => print('table is created'))
          .catchError((onError) {
        print('error is ${onError.toString()}');
      }); //create table
    }, onOpen: (db) {
      getDataFromDataBase(db);
      print('db is opened');
    }).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
  }

  insertToDatabase(
      {required String title, required String date, required String time}) {
    database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO tasks(title, date, time , status) VALUES("$title", "$date" , "$time" , "new")');
    }).then((value) {
      print('data inserted $value ');
      emit(InsertDataBaseState());
      titleController.clear();
      timeController.clear();
      dateController.clear();
      getDataFromDataBase(database);
    });
  }

  getDataFromDataBase(Database database) async {
    Newtasks = [];
    Donetasks = [];
    Archivedtasks = [];
    await database.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          Newtasks.add(element);
        } else if (element['status'] == 'done') {
          Donetasks.add(element);
        } else
          Archivedtasks.add(element);
      });

      emit(GetFromDataBaseState());
      print(Newtasks);
      print(Donetasks);
      print(Archivedtasks);
    });
  }

  updatestatus({required String status, required int id}) async {
    // Update some record
    await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      emit(UpdateDataBaseState());
      getDataFromDataBase(database);
    });
  }

  deleteRow({required int id}) async {
    // Update some record
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(DeleteDataBaseState());
      getDataFromDataBase(database);
    });
  }
}
