import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_list/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_list/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarStates());
  }

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('data created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error is when craeting table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDataBase(database);

      print('data opend');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseStates());
    });
  }



  insertToDataBase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn.rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseStates());
        getDataFromDataBase(database);
      }).catchError((error) {
        print('error when inserting new record${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDataBase(database)  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDatabaseLoadingStates());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element) {
        if(element['status']=='new') newTasks.add(element);
        else if(element['status']=='done') doneTasks.add(element);
        else archivedTasks.add(element);
      });
      emit(AppGetDatabaseStates());
    });
  }

  void updateData({
  @required String status,
  @required int id,
}) async{
   database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getDataFromDataBase(database);
          emit(AppUpdateDatabaseStates());

   });
  }

  void deleteData({
    @required int id,
  }) async{
    database.rawDelete('DELETE FROM tasks WHERE id = ?',[id])
        .then((value) {
      getDataFromDataBase(database);
      emit(AppDeleteDatabaseStates());

    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
