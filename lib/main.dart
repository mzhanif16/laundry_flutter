import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_flutter/config/app_colors.dart';
import 'package:laundry_flutter/config/app_session.dart';
import 'package:laundry_flutter/pages/auth/login_page.dart';
import 'package:laundry_flutter/pages/dashboard_page.dart';
import 'package:laundry_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
     const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    // Define your custom dark theme with white text color
    final darkTheme = ThemeData.dark().copyWith(
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white, // Set text color to white
        displayColor: Colors.white, // Set display text color to white
      ),
    );
    return MaterialApp(
      title: 'LaundryApp',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      darkTheme: darkTheme,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
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
            return const LoginPage();
          }
          return const DashboardPage();
        },
      ),
    );
  }
}
