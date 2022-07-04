import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';

class TaskItemWidget extends StatelessWidget {
  final Map task;
  
  TaskItemWidget({required this.task});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task['id'].toString()),
      onDismissed: (direction) {
        BlocProvider.of<AppCubit>(context).deleteRow(id: task['id']);
      },
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                child: Text(
                  task['time'],
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      task['date'],
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                  onPressed: () {
                    BlocProvider.of<AppCubit>(context)
                        .updatestatus(status: 'done', id: task['id']);
                  },
                  icon: const Icon(
                    Icons.check_box,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: () {
                    BlocProvider.of<AppCubit>(context)
                        .updatestatus(status: 'archive', id: task['id']);
                  },
                  icon: const Icon(
                    Icons.archive_outlined,
                    color: Colors.black54,
                  )),
            ],
          )),
    );
  }
}
