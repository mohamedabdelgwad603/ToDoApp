import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubit/cubit.dart';
import 'package:to_do_app/cubit/states.dart';

import 'package:to_do_app/widgets/build_task_item_widget.dart';

import '../../widgets/condtionBuilder_widget.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, State) {
        var tasks = BlocProvider.of<AppCubit>(context).Archivedtasks;

        return ConditionalBuilderWidget(
     
          tasks: tasks,
        );
      },
    );
  }
}
