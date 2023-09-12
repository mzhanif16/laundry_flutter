import 'package:d_button/d_button.dart';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_flutter/config/app_assets.dart';
import 'package:laundry_flutter/config/app_colors.dart';
import 'package:laundry_flutter/config/app_constants.dart';
import 'package:laundry_flutter/config/app_response.dart';
import 'package:laundry_flutter/config/failure.dart';
import 'package:laundry_flutter/datasources/user_datasource.dart';
import 'package:laundry_flutter/providers/register_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final edtUsername = TextEditingController();
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;
    setRegisterStatus(ref, 'Loading');

    UserDatasource.register(edtUsername.text, edtEmail.text, edtPassword.text)
        .then((value) {
      String newStatus = '';
      value.fold((failure) {
        switch (failure.runtimeType) {
          case ServerFailure:
            newStatus = 'Server Error';
            DInfo.toastError(newStatus);
            break;
          case NotFoundFailure:
            newStatus = 'Error Not Found';
            DInfo.toastError(newStatus);
            break;
          case ForbiddenFailure:
            newStatus = 'You Dont Have Access';
            DInfo.toastError(newStatus);
            break;
          case BadRequestFailure:
            newStatus = 'Bad Request';
            DInfo.toastError(newStatus);
            break;
          case InvalidInputFailure:
            newStatus = 'Invalid Input';
            AppResponse.invalidInput(context, failure.message ?? '{}');
            break;
          case UnauthorisedFailure:
            newStatus = 'Unauthorised';
            AppResponse.invalidInput(context, failure.message ?? '{}');
            break;
          default:
            newStatus = 'Request Error';
            DInfo.toastError(newStatus);
            newStatus = failure.message ?? '-';
            break;
        }
        setRegisterStatus(ref, newStatus);
      }, (result) {
        DInfo.toastSuccess('Daftar Berhasil');
        setRegisterStatus(ref, 'Daftar Berhasil');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.bgAuth,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black54,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: GoogleFonts.poppins(
                            fontSize: 40,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Material(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              DView.spaceWidth(10),
                              Expanded(
                                child: DInput(
                                  controller: edtUsername,
                                  fillColor: Colors.white70,
                                  hint: 'Username',
                                  radius: BorderRadius.circular(10),
                                  validator: (input) => input == ''
                                      ? "Uaername Tidak Boleh Kosong"
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DView.spaceHeight(16),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Material(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Icon(
                                    Icons.email,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              DView.spaceWidth(10),
                              Expanded(
                                child: DInput(
                                  controller: edtEmail,
                                  fillColor: Colors.white70,
                                  hint: 'Email',
                                  radius: BorderRadius.circular(10),
                                  validator: (input) => input == ''
                                      ? "Email Tidak Boleh Kosong"
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DView.spaceHeight(16),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Material(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Icon(
                                    Icons.key,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              DView.spaceWidth(10),
                              Expanded(
                                child: DInputPassword(
                                  controller: edtPassword,
                                  fillColor: Colors.white70,
                                  hint: 'Password',
                                  radius: BorderRadius.circular(10),
                                  validator: (input) => input == ''
                                      ? "Password Tidak Boleh Kosong"
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DView.spaceHeight(16),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: DButtonFlat(
                                  onClick: () {
                                    Navigator.pop(context);
                                  },
                                  padding: const EdgeInsets.all(0),
                                  radius: 10,
                                  mainColor: Colors.white70,
                                  child: const Text(
                                    'LOG',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DView.spaceWidth(10),
                              Expanded(
                                child: Consumer(
                                  builder: (_,wiRef,__) {
                                    String status = wiRef.watch(registerStatusProvider);
                                    if(status == 'Loading'){
                                      return DView.loadingCircle();
                                    }
                                    return ElevatedButton(
                                      onPressed: () => execute(),
                                      style: const ButtonStyle(
                                        alignment: Alignment.centerLeft,
                                      ),
                                      child: const Text('Register'),
                                    );
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
