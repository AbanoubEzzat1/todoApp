import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:udemy_course_todo/shared/cubit/cubit.dart';

Widget deffaultFormField({
  required TextEditingController controller,
  TextInputType? type,
  bool isPassword = false,
  VoidCallback? onTap,
  final FormFieldValidator<String>? validator,
  required String labelText,
  required IconData? prefixIcon,
  IconData? suffixIcon,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: Icon(suffixIcon),
      ),
    );

Widget deffaultTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Container(
        margin: const EdgeInsetsDirectional.only(bottom: 10),
        decoration: BoxDecoration(
          color: HexColor("#704BF4").withOpacity(0.9),
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(20),
            topEnd: Radius.circular(20),
            bottomEnd: Radius.circular(20),
            bottomStart: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: HexColor("#FFFFFF"),
                radius: 40,
                child: Text(
                  "${model['time']}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${model['title']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${model['date']}",
                      style: TextStyle(
                        color: HexColor("#272C33"),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateDataFromDatabase(
                      status: "Done",
                      id: model['id'],
                    );
                  },
                  icon: Icon(
                    Icons.check_box,
                    size: 30,
                    color: HexColor("#D5A9BB"),
                  )),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateDataFromDatabase(
                      status: "Archive",
                      id: model['id'],
                    );
                  },
                  icon: Icon(
                    Icons.archive,
                    size: 30,
                    color: HexColor("#D5A9BB"),
                  )),
            ],
          ),
        ),
      ),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          AppCubit.get(context).deleateDataFromDatabase(id: model['id']);
        } else {
          AppCubit.get(context)
              .updateDataFromDatabase(status: "New", id: model['id']);
        }
      },
      background: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        alignment: AlignmentDirectional.centerStart,
        color: Colors.blue,
        child: const Text(
          "Again To Tasks",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        alignment: AlignmentDirectional.centerEnd,
        child: const Text(
          "Delete",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        color: Colors.red,
      ),
    );
