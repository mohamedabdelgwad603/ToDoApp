import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubit/states.dart';

import '../cubit/cubit.dart';
import 'build_task_item_widget.dart';

class ConditionalBuilderWidget extends StatelessWidget {
  final List<Map> tasks;

  ConditionalBuilderWidget({required this.tasks});
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) => TaskItemWidget(task: tasks[index])),
      fallback: (context) => Center(
        child: Text(
          "Not found tasks",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
