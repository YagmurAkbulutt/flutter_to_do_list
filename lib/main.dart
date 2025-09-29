import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/ui/cubit/add_task_cubit.dart';
import 'package:to_do_list/ui/cubit/detail_cubit.dart';
import 'package:to_do_list/ui/cubit/home_cubit.dart';
import 'package:to_do_list/ui/views/home_page.dart';
import 'package:to_do_list/utils/notification_service.dart';
import 'package:flutter/services.dart';

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
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
          colorScheme: const ColorScheme.light(
            brightness: Brightness.light,
            primary: Color(0xFF6B4EFF),
            onPrimary: Color(0xFFFFFFFF),
            secondary: Color(0xFFFF6B9D),
            onSecondary: Color(0xFFFFFFFF),
            tertiary: Color(0xFF4ECDC4),
            onTertiary: Color(0xFFFFFFFF),
            surface: Color(0xFFFAFAFA),
            onSurface: Color(0xFF1A1A1A),
            surfaceVariant: Color(0xFFF5F5F5),
            onSurfaceVariant: Color(0xFF666666),
            background: Color(0xFFFFFFFF),
            onBackground: Color(0xFF1A1A1A),
            error: Color(0xFFFF6B6B),
            onError: Color(0xFFFFFFFF),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: Color(0xFF1A1A1A),
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: Color(0xFF1A1A1A),
            ),
            headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              color: Color(0xFF1A1A1A),
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF999999),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF6B4EFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: const Color(0xFFFFFFFF),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF1A1A1A),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}

