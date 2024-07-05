import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/datetime.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/noification/data/models/notificationmodel.dart';
import 'package:iclick/features/noification/presentation/cubit/noification_cubit.dart';
import 'package:iclick/features/noification/presentation/widgets/itemnotifiy.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()..getnotifiy(),
      child: BlocConsumer<NotificationCubit, NotificationState>(
        builder: (context, state) {
          NotificationCubit cubit = NotificationCubit.get(context);
          return Scaffold(
            body: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.secblack,
              onRefresh: () async {
                cubit.getnotifiy();
                SplachscreenCubit.get(context).notificount();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      NotificationModel notifiy = cubit.notifications[index];
                      return InkWell(
                        onTap: () => cubit.seennotifiy(notifiy, context),
                        child: Row(
                          children: [
                            notifiy.seen == '1'
                                ? SizedBox()
                                : CircleAvatar(
                                    radius: 5,
                                    backgroundColor: AppColors.primary,
                                  ),
                            Components.sizedwd(size: 10),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Components.defchachedimg(
                                    Stringconstants.basicimg(notifiy.user),
                                    circular: true,
                                    wid: 55,
                                    high: 55),
                              ],
                            ),
                            Components.sizedwd(size: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Components.defText(
                                      text:
                                          "${notifiy.user!.firstname} ${notifiy.user!.lastname} ${notifiy.type == 'follow' ? "Started Following You" : "${Stringconstants.typenotifiy(notifiy.type!, false)}  ${notifiy.type! == 'replay' ? 'Comment' : Stringconstants.typenotifiy(notifiy.type!, true)}"}",
                                      size: 16,
                                      lines: 2),
                                  Components.defText(
                                      text: TimeFormate.formatTimeAgo(
                                          DateTime.parse(notifiy.date!)),
                                      color: AppColors.grey.withOpacity(0.3),
                                      size: 14)
                                ],
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: AppColors.secblack,
                              radius: 15,
                              child: iconbytype(notifiy.type!),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: cubit.notifications.length),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
