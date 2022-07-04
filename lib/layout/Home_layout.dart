import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubit/cubit.dart';
import 'package:to_do_app/cubit/states.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is InsertDataBaseState) Navigator.pop(context);
        },
        builder: (context, State) {
          var cubit = BlocProvider.of<AppCubit>(context);
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fbIcon),
              onPressed: () {
                if (cubit.isBottomShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: cubit.titleController.text,
                        time: cubit.timeController.text,
                        date: cubit.dateController.text);

                    cubit.ChangeBottomShow(BottomShow: false, icon: Icons.edit);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.grey[100],
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Task tiltle field
                                  TextFormField(
                                    controller: cubit.titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? str) {
                                      if (str!.isEmpty) {
                                        return "task title must not be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide()),
                                        prefixIcon: Icon(Icons.title),
                                        labelText: 'Task title'),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  // Time tiltle field
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: cubit.timeController,
                                    validator: (String? str) {
                                      if (str!.isEmpty) {
                                        return "time must not be empty  ";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        if (value != null) {
                                          print(value.format(context));
                                          cubit.timeController.text =
                                              value.format(context);
                                        }
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide()),
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                        labelText: 'Time'),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  // Date tiltle field
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: cubit.dateController,
                                    validator: (String? str) {
                                      if (str!.isEmpty) {
                                        return "Date must not be empty  ";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2030-12-31'))
                                          .then((value) {
                                        if (value != null) {
                                          cubit.dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        }
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide()),
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                        labelText: 'Date'),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.ChangeBottomShow(BottomShow: false, icon: Icons.edit);
                  });

                  cubit.ChangeBottomShow(BottomShow: true, icon: Icons.add);
                }
              },
            ),
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeState(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done_outline_rounded), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived'),
                ]),
            body: cubit.screens[cubit.currentIndex],
          );
        },
      ),
    );
  }
}
