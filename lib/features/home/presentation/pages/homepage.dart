import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/connectivity.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/addpost/presentation/pages/newpost.dart';
import 'package:iclick/features/chat/presentation/pages/chatlist.dart';
import 'package:iclick/features/home/presentation/cubit/home_cubit.dart';
import 'package:iclick/features/home/presentation/pages/homescreen.dart';
import 'package:iclick/features/home/presentation/pages/searchuser.dart';
import 'package:iclick/features/home/presentation/widgets/homepagewid.dart';
import 'package:iclick/features/noification/presentation/pages/notification.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';
import 'package:iclick/features/reels/presentation/pages/reel.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        List screens = [
          HomeScreen(),
          ReelScreen(),
          NewPostScreen(),
          NotificationScreen(),
          SplachscreenCubit.get(context).profile == null
              ? Center(
                  child: Components.defText(text: "Error plase Restart App"),
                )
              : ProfileUserScreen(SplachscreenCubit.get(context).profile!.id!),
        ];
        return isOffline(
            widget: Scaffold(
          bottomNavigationBar: bottomnb(HomeCubit.get(context), context),
          appBar: HomeCubit.get(context).currentindex == 0 ||
                  HomeCubit.get(context).currentindex == 3
              ? AppBar(
                  title: Components.defText(
                      text: "IClick",
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      size: 30),
                  centerTitle: true,
                  actions: [
                    InkWell(
                      onTap: () => AppRoutes.animroutepush(
                          context: context, screen: ChatListScreen()),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.secblack,
                        child: Icon(
                          MyFlutterApp.chat,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    Components.sizedwd(size: 10),
                    InkWell(
                      onTap: () => AppRoutes.animroutepush(
                          context: context, screen: SearchUserScreen()),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.secblack,
                        child: Icon(
                          MyFlutterApp.search,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                )
              : null,
          body: screens[HomeCubit.get(context).currentindex],
        ));
      },
      listener: (context, state) {},
    );
  }
}
