import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/shared/components/bloc_observer.dart';
import 'layout/home_layout.dart';

void main() {
  Bloc.observer=MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
       scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.pink,
      ),
      home: HomeLayout(),
    );
  }
}
