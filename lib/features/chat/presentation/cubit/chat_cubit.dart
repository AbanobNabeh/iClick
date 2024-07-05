import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/dionotification.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/chat/data/models/MessageModel.dart';
import 'package:iclick/features/chat/data/models/chatlistModel.dart';
import 'package:iclick/features/chat/presentation/pages/viewitem.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:timezone/timezone.dart' as tz;

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  static ChatCubit get(context) => BlocProvider.of(context);
  CollectionReference chatfirestore =
      FirebaseFirestore.instance.collection('chat');
  CollectionReference blockcoll =
      FirebaseFirestore.instance.collection('block');
  UserModel? profileUser;
  TextEditingController messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isEmoji = false;
  List<ChatListModel> chatList = [];
  List<MessageModel> images = [];
  List<MessageModel> videos = [];
  List<MessageModel> files = [];
  int muteTime = 1;
  bool isMute = false;
  bool openMenuMute = false;
  bool isBlock = false;
  void getchats(BuildContext context) {
    String myID = SplachscreenCubit.get(context).profile!.id.toString();
    emit(GetChatListLoading());
    chatfirestore
        .doc(myID)
        .collection("CHAT")
        .orderBy("datetime")
        .snapshots()
        .listen((event) {
      chatList = [];
      for (var data in event.docs) {
        chatList.add(ChatListModel.fromJson(data.data()));
        emit(GetChatListSuccess());
      }
    });
  }

  void chatData(
      BuildContext context, String idUser, String lastMSG, UserModel user) {
    UserModel mydata = SplachscreenCubit.get(context).profile!;
    DioApp.getData(url: "http://worldtimeapi.org/api/timezone/Africa/Cairo")
        .then((timezone) {
      String time = timezone.data['datetime'];
      chatfirestore
          .doc(mydata.id.toString())
          .collection("CHAT")
          .doc(idUser)
          .set({
        "iduser": user.id,
        "nameuser": "${user.firstname} ${user.lastname}",
        "imageuser": user.image,
        "senderid": mydata.id,
        "lastmsg": lastMSG,
        "seen": true,
        "datetime": time,
      });
      chatfirestore
          .doc(idUser)
          .collection("CHAT")
          .doc(mydata.id.toString())
          .set({
        "iduser": mydata.id,
        "nameuser": "${mydata.firstname} ${mydata.lastname}",
        "imageuser": user.image,
        "senderid": mydata.id,
        "lastmsg": lastMSG,
        "seen": false,
        "datetime": time,
      }).then((value) {
        sendnotifiy(idUser, mydata, messageController.text, user.fcmtoken!);

        emit(SendMessageSuccess());
      });
    });
  }

  void sendmessage(BuildContext context, String idUser, UserModel user,
      {String? video, String? image, String? document}) {
    emit(SendMessageLoading());
    UserModel myID = SplachscreenCubit.get(context).profile!;
    DioApp.getData(url: "http://worldtimeapi.org/api/timezone/Africa/Cairo")
        .then((timezone) {
      String time = timezone.data['datetime'];
      chatfirestore
          .doc(myID.id.toString())
          .collection("CHAT")
          .doc(idUser)
          .collection("MESSAGE")
          .add({
        "senderid": myID.id.toString(),
        "receiverid": idUser,
        "message": messageController.text,
        "datetime": time,
        "video": video,
        "image": image,
        "document": document,
        "seen": true,
      });
      chatfirestore
          .doc(idUser)
          .collection("CHAT")
          .doc(myID.id.toString())
          .collection("MESSAGE")
          .add({
        "senderid": myID.id.toString(),
        "receiverid": idUser,
        "message": messageController.text,
        "datetime": time,
        "video": video,
        "image": image,
        "document": document,
        "seen": false,
      });
      chatData(
          context,
          idUser,
          image == null
              ? video == null
                  ? document == null
                      ? messageController.text
                      : "Document"
                  : "video"
              : "image",
          user);
      messageController.text = '';
    });
  }

  void getProfileUser(iduser) {
    emit(GetProfileUserLoading());
    DioApp.getData(url: "${AppUrl.getUserinfo}/$iduser").then((value) {
      profileUser = UserModel.fromJson(value.data['date']);
      emit(GetProfileUserSuccess());
    });
  }

  void emojiVisi(value) {
    isEmoji = value;
    emit(ChangeStateEmoji());
  }

  final ImagePicker pickerimage = ImagePicker();
  Future<void> imagePicker({required BuildContext context, phonenumber}) async {
    final photo = await pickerimage.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      AppRoutes.animroutepush(
          context: context,
          screen: ViewItemScreen(File(photo.path), profileUser!, "image", ""));
      emit(ImageSuccess());
    } else {
      emit(ImageError());
    }
  }

  final FilePicker pickerpdf = FilePicker.platform;
  Future<void> pdfPicker(
      {required BuildContext context, String? phonenumber}) async {
    FilePickerResult? result = await pickerpdf.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File pdfFile = File(result.files.single.path!);
      String fileName = p.basename(pdfFile.path);

      AppRoutes.animroutepush(
        context: context,
        screen: ViewItemScreen(pdfFile, profileUser!, "pdf", fileName),
      );
    }
  }

  final ImagePicker videopicker = ImagePicker();
  Future<void> videoPicker({required BuildContext context, phonenumber}) async {
    final XFile? video =
        await videopicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      // ignore: use_build_context_synchronously
      AppRoutes.animroutepush(
          context: context,
          screen: ViewItemScreen(File(video.path), profileUser!, "video", ""));
    } else {}
  }

  void uploadfile(
    String file,
    BuildContext context,
    String type,
    UserModel user,
  ) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file),
    });
    DioApp.postimg(url: AppUrl.uploaditemchat, data: formData).then((value) {
      sendmessage(context, user.id.toString(), user,
          image: type == 'image' ? value.data : null,
          video: type == 'video' ? value.data : null,
          document: type == 'pdf' ? value.data : null);
    });
  }

  void getimagemedia(String iduser, BuildContext context) {
    emit(GetImagesMediaLoading());
    String myID = SplachscreenCubit.get(context).profile!.id.toString();
    chatfirestore
        .doc(myID)
        .collection("CHAT")
        .doc(iduser)
        .collection("MESSAGE")
        .where('image', isNull: false)
        .get()
        .then((value) {
      images = [];

      for (var element in value.docs.reversed) {
        images.add(MessageModel.fromJson(element.data()));
      }
      emit(GetImagesMediaSuccess());
    });
  }

  void getvideoedia(String iduser, BuildContext context) {
    emit(GetVideosMediaLoading());
    String myID = SplachscreenCubit.get(context).profile!.id.toString();
    chatfirestore
        .doc(myID)
        .collection("CHAT")
        .doc(iduser)
        .collection("MESSAGE")
        .where('video', isNull: false)
        .get()
        .then((value) {
      videos = [];

      for (var element in value.docs.reversed) {
        videos.add(MessageModel.fromJson(element.data()));
      }
      emit(GetVideosMediaSuccess());
    });
  }

  void getfilesmedia(String iduser, BuildContext context) {
    emit(GetFilesMediaLoading());
    String myID = SplachscreenCubit.get(context).profile!.id.toString();
    chatfirestore
        .doc(myID)
        .collection("CHAT")
        .doc(iduser)
        .collection("MESSAGE")
        .where('document', isNull: false)
        .get()
        .then((value) {
      files = [];
      for (var element in value.docs.reversed) {
        files.add(MessageModel.fromJson(element.data()));
      }
      emit(GetFilesMediaSuccess());
    });
  }

  void changetimemute(int value) {
    muteTime = value;
    emit(ChangeTimeMuteState());
  }

  Future<String> gettime() async {
    Response response =
        await Dio().get('http://worldtimeapi.org/api/timezone/Africa/Cairo');
    String dateTimeStr = response.data['datetime'];
    DateTime dateTime = DateTime.parse(dateTimeStr);
    DateTime oneHourLater = dateTime.add(Duration(hours: muteTime));
    final location = tz.getLocation('Africa/Cairo');
    final localDateTime = tz.TZDateTime.from(oneHourLater, location);
    String formattedTime =
        DateFormat('yyyy-MM-dd – kk:mm').format(localDateTime);
    return formattedTime;
  }

  void mutenotification(String iduser, BuildContext context) {
    gettime().then((value) {
      DioApp.postData(url: AppUrl.muteNotification, data: {
        'iduser': iduser,
        'time': value,
      }).then((value) {
        isMute = true;
        emit(CheckMuteState());
      });
    });
  }

  void openTimeMute() {
    openMenuMute = !openMenuMute;
    emit(ChangeMenuMuteState());
  }

  void checkmute(int iduser) {
    DioApp.putData(url: "${AppUrl.checkmute}/$iduser").then((value) {
      if (value.data == '1') {
        isMute = true;
      }

      emit(CheckMuteState());
    });
  }

  void unmute(int iduser) {
    DioApp.deleteData(url: "${AppUrl.unmute}/$iduser").then((value) {
      openMenuMute = false;
      isMute = false;
      emit(CheckMuteState());
    });
  }

  void deletechat(BuildContext context, String iduser) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    emit(DeleteChatLoading());
    String myID = SplachscreenCubit.get(context).profile!.id.toString();
    CollectionReference messageCollection = firestore
        .collection('chat')
        .doc(myID)
        .collection('CHAT')
        .doc(iduser)
        .collection('MESSAGE');
    QuerySnapshot querySnapshot = await messageCollection.get();
    if (querySnapshot.docs.isEmpty) {
      Navigator.pop(context);
      emit(DeleteChatSuccess());
      return;
    }
    WriteBatch batch = firestore.batch();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    Navigator.pop(context);
    emit(DeleteChatSuccess());
  }

  void blockuser(BuildContext context, iduser) {
    emit(BlockUserLoading());
    String myID = SplachscreenCubit.get(context).profile!.id.toString();
    blockcoll
        .doc(myID)
        .collection('BLOCK')
        .doc(iduser)
        .set({"iduser": iduser}).then((value) {
      isBlock = true;
      Navigator.pop(context);
      emit(BlockUserSuccess());
    });
  }

  void checkblock(BuildContext context, String iduser) {
    String myID = SplachscreenCubit.get(context).profile!.id.toString();
    blockcoll
        .doc(myID)
        .collection('BLOCK')
        .where('iduser', isEqualTo: iduser)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isBlock = true;
      }
      emit(CheckBlockState());
    });
  }

  void unblockuser(BuildContext context, String iduser) {
    emit(BlockUserLoading());
    String myID = SplachscreenCubit.get(context).profile!.id.toString();
    blockcoll.doc(myID).collection('BLOCK').doc(iduser).delete().then((value) {
      isBlock = false;
      emit(BlockUserSuccess());
    });
  }

  void sendnotifiy(
      String iduser, UserModel profile, String message, String fcmtoken) {
    DioApp.putData(url: "${AppUrl.sendnotify}/$iduser").then((value) {
      if (value.data != '1') {
        APInotification.sendnotifiuser(
            to: fcmtoken,
            title: "${profile.firstname} ${profile.lastname}",
            body: message,
            type: 'chat',
            link: profile.id.toString());
      }
    });
  }
}
