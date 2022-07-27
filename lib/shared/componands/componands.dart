// ignore_for_file: non_constant_identifier_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/app_cubit.dart';

Widget mainButton({
  required BuildContext context,
  Color color = Colors.teal,
  required String text,
  double width = double.infinity,
  double? height,
  EdgeInsetsGeometry? padding,
  void Function()? onClick,
}) =>
    Padding(
      padding: padding = EdgeInsets.zero,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: MaterialButton(
            onPressed: onClick,
            child: Text(
              text,
              style: GoogleFonts.actor(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            )),
      ),
    );

void NavigateTo(BuildContext context, Widget widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void NavigateAndFinish(context, Widget widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

Widget divideLine() => Container(
      color: Colors.grey,
      width: double.infinity,
      height: 1,
    );

Widget TFF({
  required String hintText,
  required TextEditingController controller,
  required TextInputType keyboardType,
  bool isIcon = false,
  double? width,
  double? height,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20.0),
  void Function()? onTap,
  FormFieldValidator<String>? validator,
  Icon? icon,
}) =>
    Container(
      width: width = double.infinity,
      height: height = 50,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(
          color: Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          fillColor: Colors.grey[200],
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: isIcon ? icon : null,
        ),
        onTap: onTap,
        validator: validator,
        cursorColor: Colors.black,
      ),
    );

Widget buildTaskItem(Map model, context) {
  String valueString =
      model['color'].split('(0x')[1].split(')')[0]; // kind of hacky..
  int value = int.parse(valueString, radix: 16);
  Color color = Color(value);

  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction) {
      if (direction == DismissDirection.endToStart) {
        AppCubit.get(context).deleteTask(model);
      } else if (direction == DismissDirection.startToEnd) {
        AppCubit.get(context).deleteTask(model);
      }
    },
    background: Container(
      color: Colors.red[900],
      child: const ListTile(
        leading: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    ),
    secondaryBackground: Container(
      color: Colors.red[900],
      child: const ListTile(
        leading: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Checkbox(
            value: model['status'] == 'completed' ? true : false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            onChanged: (value) {
              if (value! == true) {
                AppCubit.get(context).updateTaskStatus(model,
                    model['status'] == 'completed' ? 'active' : 'completed');
              } else {
                AppCubit.get(context).updateTaskStatus(model,
                    model['status'] == 'active' ? 'completed' : 'active');
              }
            },
            checkColor: Colors.white,
            activeColor:
                model['status'] == 'completed' ? Colors.green : Colors.red,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: GoogleFonts.aldrich(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  'From : ${model['start_time']} - To : ${model['end_time']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  'Deadline : ${model['deadline']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).setFav(model);
            },
            icon: model['is_fav'] == 'true'
                ? const Icon(FontAwesomeIcons.solidHeart)
                : const Icon(FontAwesomeIcons.heart),
            color: model['is_fav'] == 'true' ? Colors.red : Colors.black,
          ),
        ],
      ),
    ),
  );
}

Widget taskBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yey, Please Insert Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
