import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:udemy_course_todo/shared/components/components.dart';
import 'package:udemy_course_todo/shared/cubit/cubit.dart';
import 'package:udemy_course_todo/shared/cubit/states.dart';

class ArchiveTasksScreen extends StatelessWidget {
  const ArchiveTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).archiveTasks;
          return tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 200,
                        color: HexColor("#704BF4").withOpacity(0.9),
                      ),
                      const Text(
                        "Archived Tasks is Empty",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Tray To Add Any Item To Archived Tasks",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return deffaultTaskItem(tasks[index], context);
                  },
                  separatorBuilder: (context, index) => Container(
                    width: double.infinity,
                    height: 1,
                  ),
                  itemCount: tasks.length,
                );
        });
  }
}
