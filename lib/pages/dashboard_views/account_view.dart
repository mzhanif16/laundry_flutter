import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_flutter/config/app_assets.dart';
import 'package:laundry_flutter/config/app_colors.dart';
import 'package:laundry_flutter/config/app_session.dart';
import 'package:laundry_flutter/config/nav.dart';
import 'package:laundry_flutter/models/user_model.dart';
import 'package:laundry_flutter/pages/auth/login_page.dart';
import 'package:laundry_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';


class Account extends ConsumerWidget {
  const Account({super.key});

  logout(BuildContext context){
    DInfo.dialogConfirmation(
        context, 'Logout', 'Apakah anda yakin ingin logout?',
        textNo: 'Cancel',
        textYes: 'Logout'
    ).then((yes) {
      if(yes??false){
        AppSession.removeBearerToken();
        AppSession.removeUser();
        Nav.replace(context, const LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return FutureBuilder(
        future: AppSession.getUser(),
        builder: (context, snapshot){
          if(snapshot.data == null) return DView.loadingCircle();
          UserModel user = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30,60,30,30),
                child: Text(
                  'Account',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 70,
                      child: AspectRatio(
                        aspectRatio: 3/4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            AppAssets.profile,
                            fit: BoxFit.cover)
                        ),
                      ),
                    ),
                    DView.spaceWidth(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          DView.spaceHeight(2),
                          Text(
                            user.username,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          DView.spaceHeight(4),
                          Text(
                            'Email',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          DView.spaceHeight(2),
                          Text(
                            user.email,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              DView.spaceHeight(10),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                onTap: (){},
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.image),
                title: const Text('Change Profile'),
                trailing: const Icon (Icons.navigate_next),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                onTap: (){},
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.edit),
                title: const Text('Edit Account'),
                trailing: const Icon (Icons.navigate_next),
              ),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 30),
               child: OutlinedButton(onPressed:() => logout(context), child: const Text(
                 'Logout'
               )),
             ),
              DView.spaceHeight(15),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Settings',
                style: GoogleFonts.poppins(
                  height: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                onTap: (){
                ref.read(themeProvider.notifier).toggleTheme();
              },
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  activeColor: AppColors.primary,
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                onTap: (){},
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.translate),
                title: const Text('Language'),
                trailing: const Icon (Icons.navigate_next),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                onTap: (){},
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.notifications),
                title: const Text('Notification'),
                trailing: const Icon (Icons.navigate_next),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                onTap: (){},
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback'),
                trailing: const Icon (Icons.navigate_next),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                onTap: (){},
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.support_agent),
                title: const Text('Support'),
                trailing: const Icon (Icons.navigate_next),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                onTap: (){
                  showAboutDialog(
                    context: context,
                    applicationIcon: const Icon(
                      Icons.local_laundry_service,
                      size: 50,
                      color: AppColors.primary,
                    ),
                    applicationName: 'Laundry App',
                    applicationVersion: 'v1.0.0',
                    children: [
                      const Text(
                        'Laundry Market App powered by Flutter'
                      )
                    ]
                  );
                },
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.info),
                title: const Text('About'),
                trailing: const Icon (Icons.navigate_next),
              ),
            ],
          );
        },
    );
  }
}
