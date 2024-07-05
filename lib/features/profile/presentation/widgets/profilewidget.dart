import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/dialog.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:iclick/features/profile/presentation/pages/editprofile.dart';

PreferredSizeWidget myAppbar(
    ProfileState state, BuildContext context, UserModel profile) {
  return AppBar(
    title: Components.defText(
        text: state is GetProfileUserLoading
            ? "Loading.."
            : "${ProfileCubit.get(context).profileUser.firstname} ${ProfileCubit.get(context).profileUser.lastname}"),
    actions: [
      IconButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BlocProvider(
                      create: (context) => ProfileCubit(),
                      child: BlocConsumer<ProfileCubit, ProfileState>(
                        builder: (context, state) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Components.sizedhg(size: 12),
                            InkWell(
                              onTap: () => AppRoutes.animroutepush(
                                  context: context,
                                  screen: EditProfileScreen(profile)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      IconBroken.Setting,
                                      color: AppColors.white,
                                    ),
                                    Components.sizedwd(size: 5),
                                    Components.defText(text: "Account Setting")
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () => showconfrimdeleteitem(context,
                                  title: "Logout",
                                  desc: "Are You Sure You Want To Logout ?",
                                  rightText: "Logout",
                                  onPressed: () => ProfileCubit.get(context)
                                      .logout(context)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      IconBroken.Logout,
                                      color: AppColors.red,
                                    ),
                                    Components.sizedwd(size: 5),
                                    Components.defText(
                                        text: "Logout", color: AppColors.red)
                                  ],
                                ),
                              ),
                            ),
                            Components.sizedhg(size: 10),
                          ],
                        ),
                        listener: (context, state) {},
                      ),
                    ),
                  );
                });
          },
          icon: Icon(MyFlutterApp.menu))
    ],
  );
}
