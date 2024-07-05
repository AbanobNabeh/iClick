import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_permission.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/app_validator.dart';
import 'package:iclick/core/utils/datetime.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/chat/data/models/MessageModel.dart';
import 'package:iclick/features/chat/data/models/chatlistModel.dart';
import 'package:iclick/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:iclick/features/chat/presentation/pages/chatscreen.dart';
import 'package:iclick/features/chat/presentation/pages/documentview.dart';
import 'package:iclick/features/chat/presentation/pages/videoplayer.dart';
import 'package:iclick/features/profile/presentation/widgets/videoitem.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:readmore/readmore.dart';

Widget bottomsheetMSG(BuildContext context, ChatCubit cubit) {
  return Padding(
    padding: const EdgeInsets.all(25.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secblack,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              itembottomshet(
                icon: IconBroken.Image_2,
                text: "Image",
                ontap: () => PermissionApp.storageperm(
                    cubit.imagePicker(context: context)),
              ),
              itembottomshet(
                icon: IconBroken.Video,
                text: "Video",
                ontap: () => PermissionApp.storageperm(
                    cubit.videoPicker(context: context)),
              ),
              itembottomshet(
                icon: IconBroken.Document,
                text: "Document",
                ontap: () => PermissionApp.storageperm(
                    cubit.pdfPicker(context: context)),
              ),
            ],
          ),
        ),
        Components.sizedhg(size: 12),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.secblack,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Components.defText(text: "Cancel", color: AppColors.red),
            ),
          ),
        )
      ],
    ),
  );
}

Widget itembottomshet(
    {required IconData icon, required String text, required Function() ontap}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: ontap,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.white,
          ),
          SizedBox(
            width: 7,
          ),
          Components.defText(text: text),
        ],
      ),
    ),
  );
}

Widget emoji(BuildContext context) {
  return EmojiPicker(
    onBackspacePressed: () {},
    textEditingController: ChatCubit.get(context).messageController,
  );
}

Widget msgSender(MessageModel message, BuildContext context, int index) {
  return Row(
    mainAxisAlignment: message.senderid ==
            SplachscreenCubit.get(context).profile!.id.toString()
        ? MainAxisAlignment.start
        : MainAxisAlignment.end,
    children: [
      message.senderid != SplachscreenCubit.get(context).profile!.id.toString()
          ? msgReceiver(message, context)
          : Container(
              constraints: const BoxConstraints(
                maxWidth: 250,
              ),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color: AppColors.primary),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    message.image == null
                        ? message.document == null
                            ? message.video == null
                                ? ReadMoreText(
                                    '${message.message}',
                                    trimMode: TrimMode.Line,
                                    trimLines: 7,
                                    colorClickableText: AppColors.primary,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    style: TextStyle(
                                        color: AppColors.white, fontSize: 20),
                                  )
                                : msgvideo(message, context)
                            : msgdocument(message,
                                AppColors.grey.withOpacity(0.3), context)
                        : msgImage(message),
                    SizedBox(
                      height: 2,
                    ),
                    Components.defText(
                        text: TimeFormate.formatTimeAgo(
                            DateTime.parse(message.datetime!)),
                        size: 16,
                        color: AppColors.grey.withOpacity(0.6)),
                  ],
                ),
              ),
            ),
    ],
  );
}

Widget msgReceiver(MessageModel message, BuildContext context) {
  return Container(
    constraints: const BoxConstraints(
      maxWidth: 250,
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8)),
        color: AppColors.secblack),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          message.image == null
              ? message.document == null
                  ? message.video == null
                      ? ReadMoreText(
                          '${message.message}',
                          trimMode: TrimMode.Line,
                          trimLines: 7,
                          colorClickableText: AppColors.primary,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          style:
                              TextStyle(color: AppColors.white, fontSize: 20),
                        )
                      : msgvideo(message, context)
                  : msgdocument(
                      message, AppColors.grey.withOpacity(0.3), context)
              : msgImage(message),
          SizedBox(
            height: 2,
          ),
          Components.defText(
              text:
                  TimeFormate.formatTimeAgo(DateTime.parse(message.datetime!)),
              size: 16,
              color: AppColors.grey.withOpacity(0.6)),
        ],
      ),
    ),
  );
}

Widget msgImage(MessageModel message) {
  return FullScreenWidget(
      disposeLevel: DisposeLevel.Low,
      child: Components.defchachedimg("${AppUrl.imagechat}${message.image}",
          high: 150, fit: BoxFit.fill));
}

Widget msgdocument(MessageModel message, Color? color, BuildContext context) {
  return InkWell(
    onTap: () => AppRoutes.animroutepush(
        context: context,
        screen: PDFviewScreen({
          'link': "${AppUrl.imagechat}${message.document}",
          "name": Stringconstants.formatpdfname(message.document!)
        })),
    child: Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(7), color: color),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Components.defText(
            text: Stringconstants.formatpdfname(message.document!)),
      ),
    ),
  );
}

Widget msgvideo(MessageModel message, BuildContext context) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) =>
              VideoPlayerScreen(url: "${AppUrl.imagechat}${message.video}"),
          backgroundColor: Colors.transparent);
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        VideoGridItem(
            chat: false, videoUrl: "${AppUrl.imagechat}${message.video}"),
        CircleAvatar(
          radius: 25,
          child: Icon(
            MyFlutterApp.play,
            color: AppColors.primary,
          ),
        )
      ],
    ),
  );
}

Widget chatItemlist(ChatListModel chat, BuildContext context) {
  return InkWell(
    onTap: () => AppRoutes.animroutepush(
        context: context, screen: ChatScreen(chat.iduser!)),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Components.defchachedimg(
              chat.imageuser == null ? AppUrl.basicimg : chat.imageuser!,
              circular: true,
              wid: 70,
              high: 70),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Components.defText(text: "${chat.nameuser}", size: 18),
                Components.defText(
                    text: "${chat.lastmsg}",
                    lines: 2,
                    color: AppColors.grey.withOpacity(0.5))
              ],
            ),
          ),
          Components.defText(
              text: TimeFormate.formatTimeAgo(DateTime.parse(
                chat.datetime.toString(),
              )),
              size: 16,
              color: AppColors.grey.withOpacity(0.6))
        ],
      ),
    ),
  );
}

Widget formChat(ChatCubit cubit, GlobalKey<FormState> formstate,
    BuildContext context, String iduser) {
  return Form(
    key: formstate,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.grey,
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) {
                        return bottomsheetMSG(context, cubit);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColors.primary,
                  )),
            ),
          ),
          Components.sizedwd(size: 7),
          Expanded(
            child: Components.defaultform(
                ontap: () => cubit.emojiVisi(false),
                controller: cubit.messageController,
                suffixIcon: Icons.send,
                suffixIcontap: () {
                  if (formstate.currentState!.validate()) {
                    cubit.sendmessage(context, iduser, cubit.profileUser!);
                  }
                },
                prefixIcon: Icons.emoji_emotions,
                prefixcolor: AppColors.primary,
                prefixIcontap: () {
                  cubit.emojiVisi(true);
                  cubit.focusNode.unfocus();
                  cubit.focusNode.canRequestFocus = false;
                },
                validator: (_) => AppValidator.messagevaild(_),
                hint: "Write Message..",
                focusNode: cubit.focusNode,
                fouce: false),
          ),
        ],
      ),
    ),
  );
}
