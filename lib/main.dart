import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_flutter/config/app_colors.dart';
import 'package:laundry_flutter/config/app_session.dart';
import 'package:laundry_flutter/pages/auth/login_page.dart';
import 'package:laundry_flutter/pages/auth/register_page.dart';
import 'package:laundry_flutter/pages/dashboard_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaundryApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(AppColors.primary),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            textStyle: const MaterialStatePropertyAll(
              TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
      home: FutureBuilder(
        future: AppSession.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DView.loadingCircle();
          }
          if (snapshot.data == null) {
            print('user: null');
            return const LoginPage();
          }
          print(snapshot.data!.toJson());
          return const DashboardPage();
        },
      ),
    );
  }
}
