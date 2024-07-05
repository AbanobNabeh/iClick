import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/features/chat/data/models/MessageModel.dart';
import 'package:iclick/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:iclick/features/chat/presentation/pages/chatdetails.dart';
import 'package:iclick/features/chat/presentation/widgets/chatitem.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';

class ChatScreen extends StatelessWidget {
  int iduser;
  ChatScreen(this.iduser, {super.key});
  @override
  Widget build(BuildContext context) {
    bool loading = true;
    List? messages;
    GlobalKey<FormState> formstate = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => ChatCubit()..getProfileUser(iduser),
      child: Builder(builder: (context) {
        return BlocConsumer<ChatCubit, ChatState>(
          builder: (context, state) {
            ChatCubit cubit = ChatCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: state is GetProfileUserLoading
                    ? Components.defText(text: "Loading..")
                    : Row(
                        children: [
                          Components.defchachedimg(
                              Stringconstants.basicimg(cubit.profileUser),
                              wid: 45,
                              high: 45,
                              circular: true),
                          Components.sizedwd(size: 5),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Components.defText(
                                  text:
                                      "${cubit.profileUser!.firstname} ${cubit.profileUser!.lastname}",
                                  size: 18),
                            ],
                          )),
                        ],
                      ),
                actions: [
                  IconButton(
                      onPressed: () => AppRoutes.animroutepush(
                          context: context,
                          screen: ChatDetailsScreen(cubit.profileUser!)),
                      icon: Icon(IconBroken.More_Circle))
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('chat')
                              .doc(SplachscreenCubit.get(context)
                                  .profile!
                                  .id
                                  .toString())
                              .collection("CHAT")
                              .doc(iduser.toString())
                              .collection("MESSAGE")
                              .orderBy("datetime")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                loading) {
                              loading = false;
                              return Center(child: Components.loadingwidget());
                            }
                            if (snapshot.hasData) {
                              messages = snapshot.data!.docs.reversed.toList();
                            }

                            return ListView.separated(
                                reverse: true,
                                itemBuilder: (context, index) {
                                  return msgSender(
                                      MessageModel.fromJson(
                                          messages![index].data()),
                                      context,
                                      index);
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 15,
                                  );
                                },
                                itemCount: messages!.length);
                          },
                        )),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('block')
                        .doc(iduser.toString())
                        .collection("BLOCK")
                        .doc(SplachscreenCubit.get(context)
                            .profile!
                            .id
                            .toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.data!.data() != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.secblack),
                                child: Center(
                                  child: Components.defText(
                                      text: "The user is not available"),
                                ),
                              ),
                            )
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('block')
                                  .doc(SplachscreenCubit.get(context)
                                      .profile!
                                      .id
                                      .toString())
                                  .collection("BLOCK")
                                  .doc(iduser.toString())
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.data!.data() != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () => ChatCubit.get(context)
                                              .unblockuser(
                                                  context, iduser.toString()),
                                          child: Container(
                                            height: 50,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors.secblack),
                                            child: Center(
                                              child: Components.defText(
                                                  text: "UnBlock"),
                                            ),
                                          ),
                                        ),
                                      )
                                    : formChat(cubit, formstate, context,
                                        iduser.toString());
                              });
                    },
                  ),
                  Visibility(visible: cubit.isEmoji, child: emoji(context))
                ],
              ),
            );
          },
          listener: (context, state) {},
        );
      }),
    );
  }
}
