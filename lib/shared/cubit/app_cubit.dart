// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_algoriza/shared/cubit/app_states.dart';

class AppCubit extends Cubit<AppStates> {
  List<DropdownMenuItem> listOfValue = [
    const DropdownMenuItem<String>(
        value: '10 min early', child: Text('10 min before')),
    const DropdownMenuItem<String>(
      value: '30 min before',
      child: Text('30 min early'),
    ),
    const DropdownMenuItem<String>(
      value: '1 hour before',
      child: Text('1 hour early'),
    ),
    const DropdownMenuItem<String>(
      value: '1 day before',
      child: Text('1 day early'),
    ),
  ];

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Color> colors = [
    const Color(0xffff3030),
    const Color(0xfffff333),
    const Color(0xff3fff33),
    const Color(0xff33aaff),
    const Color(0xffaa3fff),
  ];

  bool isSelected = false;

  dynamic selectedReminderValue;

  TabController? tabController;

  List<Tab> tabs = [
    const Tab(
      text: 'All',
    ),
    const Tab(
      text: 'Uncompleted',
    ),
    const Tab(
      text: 'Completed',
    ),
    const Tab(
      text: 'Favourite',
    ),
  ];
  String errorMessage = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController deadLineController = TextEditingController();
  TextEditingController remindController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController repeatController = TextEditingController();

  dynamic colorSelected;

  Database? database;
  List<Map> tasks = [];
  List<Map> activeTasks = [];
  List<Map> completedTasks = [];
  List<Map> favouriteTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 2,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, start_time TEXT, end_time TEXT, deadline TEXT, remind TEXT, color BLOB, status TEXT, is_fav TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('Error is ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
        getDataFromDataBase(database);
        print('data received From Database successfully');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseSuccess());
    });
  }

  insertToDatabase({
    required BuildContext context,
    required String title,
    required String startTime,
    required String endTime,
    required String deadline,
    required String remind,
    required Color color,
    String status = 'all',
    bool isFav = false,
  }) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, start_time, end_time, deadline, remind, color, status, is_fav) VALUES("$title","$startTime","$endTime","$deadline","$remind","$color","$status","$isFav")')
          .then((value) {
        print('$value is inserting successfully');
        emit(AppInsertDatabaseSuccessfulState());
        getDataFromDataBase(database);
      }).catchError((error) {
        print('Error when Insert new raw Record ${error.toString()}');
      });
    });
  }

  void getDataFromDataBase(database) {
    tasks = [];
    activeTasks = [];
    completedTasks = [];
    favouriteTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery("SELECT * FROM Tasks").then((value) {
      tasks = value;
      print('tasks $tasks');
      value.forEach((element) {
        if (element['status'] == 'completed') {
          completedTasks.add(element);
        } else if (element['status'] == 'uncompleted') {
          activeTasks.add(element);
        }
        if (element['is_fav'] == 'true') {
          favouriteTasks.add(element);
        }
      });
      emit(AppGetDatabaseSuccessfulState());
    });
  }

  void setChecked({required bool value}) {
    value = !value;
    emit(AppSetCheckedSuccess(value));
  }

  void updateTaskStatus(Map model, s) {
    emit(AppUpdateTaskStatusLoadingState());
    database
        ?.rawUpdate(
            'UPDATE tasks SET status = "$s" WHERE id = "${model['id']}"')
        .then((value) {
      print('${model['title']} is updated successfully');
      emit(AppUpdateTaskStatusSuccessfulState());
      getDataFromDataBase(database);
    }).catchError((error) {
      print('Error when update ${model['title']} ${error.toString()}');
      emit(AppUpdateTaskStatusErrorState(error));
    });
  }

  void setFav(Map<dynamic, dynamic> model) {
    emit(AppSetFavLoadingState());
    database
        ?.rawUpdate(
            'UPDATE tasks SET is_fav = "${model['is_fav'] == 'true' ? 'false' : 'true'}" WHERE id = "${model['id']}"')
        .then((value) {
      print('${model['title']} is updated successfully');
      emit(AppSetFavSuccessfulState());
      getDataFromDataBase(database);
    }).catchError((error) {
      print('Error when update ${model['title']} ${error.toString()}');
      emit(AppSetFavErrorState(error));
    });
  }

  void deleteTask(Map<dynamic, dynamic> model) {
    emit(AppDeleteTaskLoadingState());
    database
        ?.rawDelete('DELETE FROM tasks WHERE id = "${model['id']}"')
        .then((value) {
      debugPrint('${model['title']} is deleted successfully');
      emit(AppDeleteTaskSuccessfulState());
      getDataFromDataBase(database);
    }).catchError((error) {
      debugPrint('Error when delete ${model['title']} ${error.toString()}');
      emit(AppDeleteTaskErrorState(error));
    });
  }

  void setColor(Color color) {
    isSelected = true;
    colorSelected = color;
    emit(AppChangeColorStates());
  }

  DateTime? scheduleDate;

  void setDate(DateTime date) {
    scheduleDate = date;
    emit(AppChangeDateStates());
  }
}
