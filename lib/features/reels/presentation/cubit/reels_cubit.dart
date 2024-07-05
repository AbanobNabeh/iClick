import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/dionotification.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/reels/data/models/commentmodel.dart';
import 'package:iclick/features/reels/data/models/reelmodel.dart';
import 'package:iclick/features/reels/data/models/repliesmodel.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
part 'reels_state.dart';

class ReelsCubit extends Cubit<ReelsState> {
  ReelsCubit() : super(ReelsInitial());
  static ReelsCubit get(context) => BlocProvider.of(context);
  List<ReelModel> reels = [];
  List<CommentModel> comments = [];
  List<RepliesModel> replies = [];
  FocusNode commentfoc = FocusNode();
  TextEditingController commentcon = TextEditingController();
  bool volumedown = false;
  int? showreplies;
  int pageReel = 1;
  CommentModel? isreplay;
  PageController controller = PageController();
  ReelModel? reelbyid;
  void getreel() {
    pageReel == 1 ? emit(GetReelloading()) : emit(LoadReelLoading());
    DioApp.getData(url: AppUrl.getreels, query: {"page": pageReel})
        .then((value) {
      pageReel == 1 ? reels = [] : null;
      value.data['data'].forEach((element) {
        reels.add(ReelModel.fromJson(element));
      });
      emit(GetReelsuccess());
    });
  }

  void likereel(ReelModel reelModel, BuildContext context) {
    emit(LikeReelLoading());
    UserModel profile = SplachscreenCubit.get(context).profile!;

    DioApp.postData(
        url: AppUrl.addlike,
        data: {'idpost': reelModel.id, "type": 'reel'}).then((value) {
      int numlike = int.parse(reelModel.like!);
      if (value.data['message'] == 'like') {
        reelModel.liked = true;
        reelModel.like = "${numlike + 1}";
        APInotification.sendnotifiuser(
            to: reelModel.user!.fcmtoken!,
            title: "${profile.firstname} ${profile.lastname}",
            body: 'Liked Your Reel',
            type: "reel",
            link: reelModel.id.toString());
        emit(LikeReelSuccess());
      } else {
        reelModel.liked = false;
        reelModel.like = "${numlike - 1}";
        emit(UnLikeReelSuccess());
      }
    });
  }

  void addcomment(String idpost, BuildContext context) {
    emit(AddCommentLoading());
    UserModel profile = SplachscreenCubit.get(context).profile!;
    DioApp.postData(url: AppUrl.comment, data: {
      'comment': commentcon.text,
      'idpost': idpost,
      "type": "reel"
    }).then((value) {
      APInotification.sendnotifiuser(
          to: value.data['FCMtoken']['FCMtoken'],
          title: "${profile.firstname} ${profile.lastname}",
          body: 'Commented "${commentcon.text}"',
          type: "reel",
          link: idpost);
      comments.insert(
          0,
          CommentModel(
              id: value.data['date']['id'],
              comment: commentcon.text,
              link: idpost,
              type: 'comment',
              date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
              like: "0",
              liked: false,
              replies: 0,
              userinfo: SplachscreenCubit.get(context).profile!,
              iduser: SplachscreenCubit.get(context).profile!.id.toString()));
      commentcon.text = '';
      emit(AddCommentSuccess());
    });
  }

  void getcomment(String idpost) {
    emit(GetCommentLoading());
    DioApp.postData(
        url: AppUrl.getcomment,
        data: {'idpost': idpost, 'type': "reel"}).then((value) {
      comments = [];
      value.data['data']['data'].forEach((element) {
        comments.add(CommentModel.fromJson(element));
      });
      emit(GetCommentSuccess());
    });
  }

  void replay(CommentModel? value) {
    isreplay = value;
    emit(IsReplayState());
  }

  void addreplay() {
    emit(AddReplayLoading());
    isreplay!.id == null
        ? null
        : DioApp.postData(url: AppUrl.replaycomment, data: {
            'idcomment': isreplay!.id,
            "replay": commentcon.text,
          }).then((value) {
            isreplay!.replies = isreplay!.replies! + 1;
            commentcon.text = '';
            replay(null);
          });
  }

  void getreplies(int idcomment) {
    showreplies = idcomment;
    emit(GetReplayLoading());
    DioApp.postData(url: AppUrl.getreplies, data: {'idcomment': idcomment})
        .then((value) {
      replies = [];
      value.data['data'].forEach((element) {
        replies.add(RepliesModel.fromJson(element));
      });
      emit(GetReplaySuccess());
    });
  }

  void likecomment(CommentModel comment) {
    emit(LikeCommentLoading());
    DioApp.postData(url: AppUrl.likecom, data: {'idcomment': comment.id})
        .then((value) {
      int numlike = int.parse(comment.like!);
      if (value.data['message'] == 'like') {
        comment.liked = true;
        comment.like = "${numlike + 1}";
        emit(LikeCommentSuccess());
      } else {
        comment.liked = false;
        comment.like = "${numlike - 1}";
        emit(LikeCommentSuccess());
      }
    });
  }

  void likereplay(RepliesModel replay) {
    emit(LikeReplayLoading());
    DioApp.postData(url: AppUrl.likereplay, data: {'idpost': replay.id})
        .then((value) {
      int numlike = int.parse(replay.like!);
      if (value.data['message'] == 'like') {
        replay.liked = true;
        replay.like = "${numlike + 1}";
        emit(LikeReplaySuccess());
      } else {
        replay.liked = false;
        replay.like = "${numlike - 1}";
        emit(LikeReplaySuccess());
      }
    });
  }

  void deletecomment(int id, BuildContext context, String idpost) {
    DioApp.deleteData(url: "${AppUrl.deletecomment}/$id").then((value) {
      Navigator.pop(context);
      getcomment(idpost);
    });
  }

  void deletereplay(int id, BuildContext context) {
    DioApp.deleteData(url: "${AppUrl.deletereplay}/$id").then((value) {
      Navigator.pop(context);
      showreplies = null;
      emit(DeleteReplay());
    });
  }

  void sharereel(int id) async {
    Share.share("${AppUrl.sharelink}?reel=$id");
  }

  void scrollLoad() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        pageReel = pageReel + 1;
        getreel();
      }
    });
  }

  void getreelbyid(int id) {
    emit(GetReelByIDLoading());
    DioApp.postData(url: AppUrl.getreelbyid, data: {"idreel": id})
        .then((value) {
      reelbyid = ReelModel.fromJson(value.data);
      emit(GetReelByIDuccess());
    });
  }
}
