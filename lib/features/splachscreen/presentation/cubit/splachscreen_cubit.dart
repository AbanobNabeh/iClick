import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/auth/presentation/pages/signin.dart';
import 'package:iclick/features/home/presentation/pages/homepage.dart';

part 'splachscreen_state.dart';

class SplachscreenCubit extends Cubit<SplachscreenState> {
  SplachscreenCubit() : super(SplachscreenInitial());
  static SplachscreenCubit get(context) => BlocProvider.of(context);
  int boardingindex = 0;
  ConnectivityResult? isconnect;
  int notifiyunseen = 0;

  void checkconnect() {
    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      isconnect = result[0];
      emit(CheckConeectState());
    });
  }

  void init(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      if (Stringconstants.token == null) {
        AppRoutes.animroute(context: context, screen: SigninScreen());
      } else {
        AppRoutes.animroute(context: context, screen: HomePage());
      }
    });
  }

  UserModel? profile;
  void getprofile() {
    if (Stringconstants.token != null) {
      DioApp.getData(url: AppUrl.getmyprofile).then((value) {
        print(value.data);
        profile = UserModel.fromJson(value.data);
      });
    }
  }

  void notificount() {
    DioApp.getData(url: AppUrl.countnotifiy).then((value) {
      notifiyunseen = int.parse(value.data);
    });
  }
}
