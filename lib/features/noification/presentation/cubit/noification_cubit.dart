import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/features/home/presentation/pages/postview.dart';
import 'package:iclick/features/noification/data/models/notificationmodel.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';
import 'package:iclick/features/reels/presentation/pages/rellview.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';

part 'noification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NoificationInitial());
  static NotificationCubit get(context) => BlocProvider.of(context);
  List<NotificationModel> notifications = [];

  void getnotifiy() {
    notifications = [];
    emit(GetNotifiyLoading());
    DioApp.getData(url: AppUrl.getnotifiy).then((value) {
      value.data['data']['data'].forEach((element) {
        notifications.add(NotificationModel.fromJson(element));
      });
      emit(GetNotifiySuccess());
    });
  }

  void seennotifiy(NotificationModel notification, BuildContext context) {
    emit(SeenNotifiyLoading());
    DioApp.putData(
      url: "${AppUrl.seennotify}/${notification.id}",
    ).then((value) {
      SplachscreenCubit.get(context).notificount();
      notification.seen = '1';
      if (Stringconstants.typenotifiy(notification.type!, true) == 'Photo') {
        AppRoutes.animroutepush(
            context: context, screen: PostView(int.parse(notification.link!)));
      } else if (Stringconstants.typenotifiy(notification.type!, true) ==
          'Reel') {
        AppRoutes.animroutepush(
            context: context,
            screen: ReelViewScreen(int.parse(notification.link!)));
      } else if (notification.type! == 'follow') {
        print("Asd");
      }
      emit(SeenNotifiySuccess());
    });
  }
}
