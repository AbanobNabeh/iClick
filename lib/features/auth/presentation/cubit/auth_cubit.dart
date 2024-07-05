import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/config/shared%20preferences/shared_preferences.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/features/home/presentation/pages/homepage.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);
  FocusNode emailfoc = FocusNode();
  FocusNode passwordfoc = FocusNode();
  FocusNode firstnamefoc = FocusNode();
  FocusNode lastnamefoc = FocusNode();
  FocusNode confrimpassfoc = FocusNode();
  FocusNode OTPfoc = FocusNode();
  TextEditingController firstnamecon = TextEditingController();
  TextEditingController lastnamecon = TextEditingController();
  TextEditingController emailcon = TextEditingController();
  TextEditingController passcon = TextEditingController();
  TextEditingController confrimpasscon = TextEditingController();
  TextEditingController OTPcon = TextEditingController();
  int indexpage = 0;
  bool emailused = false;
  IconData visipw = IconBroken.Hide;
  bool obscureText = true;
  bool otperror = false;
  bool emailerror = false;
  int forgotpwindex = 0;
  bool loginerror = false;
  void unfouce(FocusNode focusNode) {
    focusNode.unfocus();
    emit(UnFouceChange());
  }

  void changemail() {
    indexpage = 0;
    emit(ChangeMailstate());
  }

  void verifymail() {
    emit(VerifyEmailLoading());
    DioApp.postData(
            url: AppUrl.verifyotp,
            data: {"firstname": firstnamecon.text, 'email': emailcon.text})
        .then((value) {
      if (value.data['status'] == 'used') {
        emailused = true;
        emit(EmailUsedState());
      } else {
        indexpage = 1;
        emit(VerifyEmailSuccess());
      }
    });
  }

  void changeobscure() {
    obscureText ? visipw = IconBroken.Show : visipw = IconBroken.Hide;
    obscureText = !obscureText;
    emit(ChangeObscureState());
  }

  void signup(BuildContext context) async {
    otperror = false;
    String? token = await FirebaseMessaging.instance.getToken();

    emit(SignUpLoading());
    DioApp.postData(url: AppUrl.signup, data: {
      "firstname": firstnamecon.text,
      "lastname": lastnamecon.text,
      "email": emailcon.text,
      'FCMtoken': token,
      "password": passcon.text,
      "otp": OTPcon.text
    }).then((value) {
      if (value.data['status'] == 'codeisinvalid') {
        otperror = true;
        emit(OTPVaildState());
      } else {
        CacheHelper.saveData(
                key: Stringconstants.isuser, value: value.data['token'])
            .then((_) {
          Stringconstants.token = value.data['token'];
          DioApp.updateAuthorizationToken(value.data['token']);
          SplachscreenCubit.get(context).getprofile();
          AppRoutes.animrouteremove(context: context, screen: HomePage());
        });
      }
    });
  }

  void checkemail(BuildContext context) {
    emailerror = false;
    emit(CheckEmailLoading());
    DioApp.postData(url: AppUrl.checkmail, data: {'email': emailcon.text})
        .then((value) {
      if (value.data['status'] == 'notused') {
        emailerror = true;
        emit(EmailNotUsedState());
      } else if (value.data['status'] == 'true') {
        forgotpwindex = 1;
        emit(CheckEmailSuccess());
      }
    });
  }

  void forgotpassword(BuildContext context) {
    emit(ForgotPasswordLoading());
    DioApp.postData(url: AppUrl.forgotpassword, data: {
      'email': emailcon.text,
      'otp': OTPcon.text,
      "password": passcon.text
    }).then((value) async {
      if (value.data['status'] == 'codeisinvalid') {
        otperror = true;
        forgotpwindex = 1;
        emit(OTPVaildState());
      } else if (value.data['status'] == 'true') {
        Components.successmessage(
            context: context,
            message: 'The password has been changed successfully');
        forgotpwindex = 0;

        emit(ForgotPasswordSuccess());
      }
    });
  }

  void signin(BuildContext context) async {
    loginerror = false;
    String? token = await FirebaseMessaging.instance.getToken();
    emit(SignInLoading());
    DioApp.postData(url: AppUrl.login, data: {
      'email': emailcon.text,
      'password': passcon.text,
      'fcmtoken': token,
    }).then((value) {
      if (value.data['status'] == 'loginisinvalid') {
        loginerror = true;
        emit(LoginError());
      } else {
        CacheHelper.saveData(
                key: Stringconstants.isuser, value: value.data['token'])
            .then((_) {
          Stringconstants.token = value.data['token'];
          DioApp.updateAuthorizationToken(value.data['token']);
          SplachscreenCubit.get(context).getprofile();
          AppRoutes.animrouteremove(context: context, screen: HomePage());
          emit(SignInSuccess());
        });
      }
    });
  }
}
