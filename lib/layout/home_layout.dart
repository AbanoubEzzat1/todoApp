import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_course_todo/modules/archive_tasks/archive_tasks.dart';
import 'package:udemy_course_todo/modules/done_tasks/done_tasks.dart';
import 'package:udemy_course_todo/modules/new_tasks/new_tasks.dart';
import 'package:udemy_course_todo/shared/components/components.dart';
import 'package:udemy_course_todo/shared/components/constant.dart';
import 'package:udemy_course_todo/shared/cubit/cubit.dart';
import 'package:udemy_course_todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  HexColor primaryColor = HexColor("#7604B4");
  HexColor secondaryColor = HexColor("#C55FFC");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, state) {
        if (state is AppInsertIntoDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, Object? state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: primaryColor,
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 30,
                start: 20,
              ),
              child: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: HexColor("#704BF4").withOpacity(0.9),
              backgroundColor: Colors.white,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archive"),
              ]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: HexColor("#704BF4"),
            onPressed: () {
              if (cubit.isButtomSow) {
                if (formKey.currentState!.validate()) {
                  cubit.insertIntoDatabase(
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text,
                  );

                  Navigator.pop(context);
                  cubit.changeBottomSheetState(
                    isShow: false,
                    icon: Icons.edit,
                  );
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet((context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsetsDirectional.only(top: 10),
                          decoration: BoxDecoration(
                            color: HexColor("#D5A9BB").withOpacity(0.9),
                            borderRadius: const BorderRadiusDirectional.only(
                              topStart: Radius.circular(20),
                              topEnd: Radius.circular(20),
                            ),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  deffaultFormField(
                                    controller: titleController,
                                    labelText: "Task Title",
                                    prefixIcon: Icons.title,
                                    onTap: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ('Task Title cant be empty');
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  deffaultFormField(
                                    controller: timeController,
                                    labelText: "Task Time",
                                    prefixIcon: Icons.title,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        builder: (context, child) {
                                          return Theme(
                                              data: ThemeData.dark(),
                                              child: child!);
                                        },
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context);
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ('Task Time cant be empty');
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  deffaultFormField(
                                    controller: dateController,
                                    labelText: "Task Date",
                                    prefixIcon: Icons.title,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2023-06-31'),
                                        builder: (context, child) {
                                          return Theme(
                                              data: ThemeData.dark(),
                                              child: child!);
                                        },
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                        print(DateFormat.yMMMd().format(value));
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ('Task Date cant be empty');
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    .closed
                    .then((value) {
                      cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    });
                cubit.changeBottomSheetState(
                  isShow: true,
                  icon: Icons.add,
                );
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: const EdgeInsetsDirectional.only(
                start: 0,
                end: 0,
                top: 70,
                bottom: 0,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(50),
                  topEnd: Radius.circular(50),
                ),
              ),
              child: cubit.Screens[cubit.currentIndex]),
        );
      }),
    );
  }
}
