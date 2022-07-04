import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/cubit/cubit.dart';
import 'package:to_do_app/layout/Home_layout.dart';
import 'cubit/observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {        
  const MyApp({Key? key}) : super(key: key);  
  
  @override   
  Widget build(BuildContext context) {     
    return MaterialApp(   
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
