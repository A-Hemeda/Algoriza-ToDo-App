import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_algoriza/shared/cubit/app_cubit.dart';
import 'package:todo_list_algoriza/shared/cubit/app_states.dart';
import '../../shared/componands/componands.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var allTasks = AppCubit.get(context).tasks;
        return taskBuilder(tasks: allTasks);
      },
    );
  }
}
