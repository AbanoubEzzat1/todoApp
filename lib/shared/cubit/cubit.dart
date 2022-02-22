import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_course_todo/modules/archive_tasks/archive_tasks.dart';
import 'package:udemy_course_todo/modules/done_tasks/done_tasks.dart';
import 'package:udemy_course_todo/modules/new_tasks/new_tasks.dart';
import 'package:udemy_course_todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> Screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen()
  ];
  List<String> titles = [
    "New Tasks",
    "Done Tasks",
    "Archive Tasks",
  ];
  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  IconData fabIcon = Icons.edit;
  bool isButtomSow = false;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isButtomSow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  late Database database;
  //List<Map> newTasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase() {
    openDatabase(
      "ToDoApp.db",
      version: 1,
      onCreate: (database, version) {
        print("Database Created");
        database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY,title Text , date TEXT , time TEXT , status TEXT)')
            .then((value) {
          print("Tasks Table Created");
        }).catchError((erorr) {
          print("Erorr When Tasks Table Created ${erorr.toString()}");
        });
      },
      onOpen: (database) {
        print("Database Open");
        getDataFromDatabase(database: database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void insertIntoDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time", "New")')
          .then((value) {
        print("$value Insert Successfully");
        getDataFromDatabase(database: database);
      }).catchError((erorr) {
        print("Erorr When Insert Into Tasks Table  ${erorr.toString()}");
      });
    });
  }

  void getDataFromDatabase({required Database database}) async {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    await database.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'New') {
          newTasks.add(element);
        } else if (element['status'] == 'Done') {
          doneTasks.add(element);
        } else if (element['status'] == 'Archive') {
          archiveTasks.add(element);
        }
        print(element['status']);
      });
      print(newTasks);
      emit(AppGetDatabaseState());
    }).catchError((erorr) {
      print("Erorr When Get Data From Tasks Table  ${erorr.toString()}");
    });
  }

  void updateDataFromDatabase({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database: database);
    }).catchError((erorr) {
      print("erorr when update Status row in database ${erorr.toString()}");
    });
  }

  void deleateDataFromDatabase({required int id}) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database: database);
      emit(AppDeletFromDatabaseState());
    }).catchError((erorr) {
      print("erorr when deleting row [$id] from table Tasks");
    });
  }
}
