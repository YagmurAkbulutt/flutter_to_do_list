import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/ui/cubit/add_task_cubit.dart';
import 'package:to_do_list/ui/cubit/detail_cubit.dart';
import 'package:to_do_list/ui/cubit/home_cubit.dart';
import 'package:to_do_list/ui/views/home_page.dart';
import 'package:to_do_list/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService.init();
  final now = DateTime.now().add(const Duration(minutes: 1));
  await NotificationService.scheduleNotification("Test Görevi", now);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => DetailCubit()),
        BlocProvider(create: (context) => AddTaskCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        ),
        home: const HomePage(),
      ),
    );
  }
}

