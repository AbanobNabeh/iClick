import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/chat/data/models/chatlistModel.dart';
import 'package:iclick/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:iclick/features/chat/presentation/widgets/chatitem.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool loading = true;
    List? chatlist;
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Components.defText(
                  text: "${SplachscreenCubit.get(context).profile!.username}"),
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .doc(SplachscreenCubit.get(context).profile!.id.toString())
                    .collection("CHAT")
                    .orderBy("datetime")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      loading) {
                    loading = false;
                    return Center(child: Components.loadingwidget());
                  }
                  if (snapshot.hasData) {
                    chatlist = snapshot.data!.docs.reversed.toList();
                  }
                  return loading
                      ? Center(child: Components.loadingwidget())
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            return chatItemlist(
                                ChatListModel.fromJson(chatlist![index].data()),
                                context);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: chatlist!.length);
                }),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
