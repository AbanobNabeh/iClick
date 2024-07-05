import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/dialog.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:iclick/features/chat/presentation/pages/mediachat.dart';
import 'package:iclick/features/chat/presentation/widgets/profileitem.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel user;
  ChatDetailsScreen(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit()
        ..checkmute(user.id!)
        ..checkblock(context, user.id.toString()),
      child: BlocConsumer<ChatCubit, ChatState>(
        builder: (context, state) {
          ChatCubit cubit = ChatCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Components.defText(
                  text: "${user.firstname} ${user.lastname}"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Components.sizedhg(),
                    Components.defchachedimg(Stringconstants.basicimg(user),
                        circular: true, wid: 100, high: 100),
                    Components.sizedhg(),
                    Components.defText(text: "@${user.username}"),
                    Components.sizedhg(),
                    user.bio == null
                        ? SizedBox()
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.secblack),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Components.defText(
                                  text: user.bio!, textAlign: TextAlign.center),
                            ),
                          ),
                    Components.sizedhg(),
                    itemprofiledet(
                        () => AppRoutes.animroutepush(
                            context: context,
                            screen: MediaChatScreen(user.id.toString())),
                        IconBroken.Image,
                        "Media",
                        true),
                    itemprofiledet(
                        () => AppRoutes.animroutepush(
                            context: context,
                            screen: ProfileUserScreen(user.id!)),
                        IconBroken.Profile,
                        "Show Profile",
                        true),
                    cubit.isMute
                        ? itemprofiledet(() => cubit.unmute(user.id!),
                            IconBroken.Volume_Up, "UnMute", false)
                        : cubit.openMenuMute
                            ? menuMute(IconBroken.Volume_Off, "Mute", cubit,
                                context, user.id.toString())
                            : itemprofiledet(() => cubit.openTimeMute(),
                                IconBroken.Volume_Off, "Mute", true),
                    itemprofiledet(() async {
                      final result = await showconfrimdeleteitem(
                        onPressed: () =>
                            cubit.deletechat(context, user.id.toString()),
                        context,
                        rightText: "Delete",
                        title: "Delete",
                        desc: "Delete Chat ${user.firstname}",
                      );

                      if (result) {
                        Navigator.pop(context);
                      }
                    }, IconBroken.Delete, "Clear Chat", false),
                    cubit.isBlock
                        ? itemprofiledet(
                            () async =>
                                cubit.unblockuser(context, user.id.toString()),
                            MyFlutterApp.block,
                            "UnBlock",
                            false)
                        : itemprofiledet(() async {
                            final result = await showconfrimdeleteitem(
                              onPressed: () =>
                                  cubit.blockuser(context, user.id.toString()),
                              context,
                              rightText: "Block",
                              title: "Block",
                              desc: "Block Chat ${user.firstname}",
                            );

                            if (result) {
                              Navigator.pop(context);
                            }
                          }, MyFlutterApp.block, "Block", false),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
