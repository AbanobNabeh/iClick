import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/dionotification.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/features/addpost/presentation/cubit/addpost_cubit.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/home/data/models/postmodel.dart';
import 'package:iclick/features/home/data/models/storiesmodel.dart';
import 'package:iclick/features/home/data/models/viewstorymodel.dart';
import 'package:iclick/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:iclick/features/reels/data/models/commentmodel.dart';
import 'package:iclick/features/reels/data/models/repliesmodel.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  int currentindex = 0;
  File? image;
  final ImagePicker pickerimage = ImagePicker();
  List<UserModel> stories = [];
  List<Stories> mystory = [];
  List<ViewStoryModel> viewrs = [];
  List<PostModel> posts = [];
  int pagePosts = 1;
  final controllerscroll = ScrollController();
  FocusNode commentfoc = FocusNode();
  TextEditingController commentcon = TextEditingController();
  CommentModel? isreplay;
  List<CommentModel> comments = [];
  List<RepliesModel> replies = [];
  int? showreplies;
  List<UserModel> userssearch = [];
  TextEditingController searchusercon = TextEditingController();
  FocusNode searchuserfoc = FocusNode();

  void changeindex(int index, BuildContext context) {
    currentindex = index;
    switch (index) {
      case 0:
        emit(ChangeIndexState());
        if (controllerscroll.offset.toInt() >= 500) {
          controllerscroll.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        break;
      case 2:
        emit(ChangeIndexState());
        AddpostCubit.get(context).getimages();
        break;
      case 3:
        SplachscreenCubit.get(context).notificount();
        emit(ChangeIndexState());
        break;
      default:
        emit(ChangeIndexState());
        break;
    }
  }

  Future<void> selectImage(BuildContext context) async {
    final cover = await pickerimage.pickImage(source: ImageSource.gallery);
    if (cover != null) {
      image = File(cover.path);
      emit(ImageSuccess());
    } else {
      print('No Image Selected');
      emit(ImageError());
    }
  }

  void getstories() {
    stories = [];
    mystory = [];
    emit(GetStoriesLoading());
    DioApp.getData(url: AppUrl.getstories).then((value) {
      value.data['data'].forEach((element) {
        stories.add(UserModel.fromJson(element));
      });
      value.data['mystories'].forEach((element) {
        mystory.add(Stories.fromJson(element));
      });
      emit(GetStoriesSuccess());
    });
  }

  void watchstory(int storyid) {
    DioApp.postData(url: AppUrl.watchstory, data: {'storyid': storyid})
        .then((value) {});
  }

  void likestory(int storyid) {
    DioApp.postData(url: AppUrl.likestory, data: {'storyid': storyid})
        .then((value) {});
  }

  void getviewrsstory(int storyid) {
    emit(GetViewersLoading());
    DioApp.postData(url: AppUrl.getviewers, data: {'ispost': storyid})
        .then((value) {
      value.data['data'].forEach((element) {
        viewrs.add(ViewStoryModel.fromJson(element));
      });
      emit(GetViewersSuccess());
    });
  }

  void getposts() {
    pagePosts == 1 ? posts = [] : null;
    pagePosts == 1 ? emit(GetPostsLoading()) : null;
    DioApp.getData(url: AppUrl.getposts, query: {"page": pagePosts})
        .then((value) {
      value.data['date']['data'].forEach((element) {
        posts.add(PostModel.fromJson(element));
      });
      emit(GetPostsSuccess());
    });
  }

  void sharereel(int id) async {
    Share.share("${AppUrl.sharelink}?post=$id");
  }

  void addcomment(String idpost, BuildContext context) {
    emit(AddCommentLoading());
    UserModel profile = SplachscreenCubit.get(context).profile!;
    DioApp.postData(url: AppUrl.comment, data: {
      'comment': commentcon.text,
      'idpost': idpost,
      "type": "post"
    }).then((value) {
      APInotification.sendnotifiuser(
          to: value.data['FCMtoken']['FCMtoken'],
          title: "${profile.firstname} ${profile.lastname}",
          body: 'Commented "${commentcon.text}"',
          type: "post",
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
    comments = [];
    emit(GetCommentLoading());
    DioApp.postData(
        url: AppUrl.getcomment,
        data: {'idpost': idpost, 'type': "post"}).then((value) {
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
            showreplies = null;
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

  void likepost(PostModel postModel, BuildContext context) {
    postModel.liked = !postModel.liked!;
    emit(LikeReelLoading());
    UserModel profile = SplachscreenCubit.get(context).profile!;
    DioApp.postData(
        url: AppUrl.addlike,
        data: {'idpost': postModel.id, "type": 'post'}).then((value) {
      int numlike = int.parse(postModel.likes!);
      if (value.data['message'] == 'like') {
        postModel.liked = true;
        postModel.likes = "${numlike + 1}";
        APInotification.sendnotifiuser(
            to: postModel.user!.fcmtoken!,
            title: "${profile.firstname} ${profile.lastname}",
            body: 'Liked Your Photo',
            type: "post",
            link: postModel.id.toString());
        emit(LikeReelSuccess());
      } else {
        postModel.liked = false;
        postModel.likes = "${numlike - 1}";
        emit(UnLikeReelSuccess());
      }
    });
  }

  PostModel? postbyid;
  void getpostbyid(int id) {
    emit(GetPostIDLoading());
    DioApp.postData(url: AppUrl.getpostbyid, data: {"postid": id})
        .then((value) {
      postbyid = PostModel.fromJson(value.data);
      emit(GetPostIDSuccess());
    });
  }

  void follow(PostModel post, BuildContext context) {
    UserModel myprofile = SplachscreenCubit.get(context).profile!;

    DioApp.postData(url: AppUrl.follow, data: {"iduser": post.user!.id!})
        .then((value) {
      post.relationship = 'follow';
      APInotification.sendnotifiuser(
          to: post.user!.fcmtoken!,
          title: "${myprofile.firstname} ${myprofile.lastname}",
          body: "Started Following You",
          type: "user",
          link: myprofile.id.toString());
      APInotification.subscribeToTopic("USER${post.user!.id.toString()}");
      emit(FollowUserState());
    });
  }

  void searchUser(value) {
    emit(SearchUsersLoading());
    userssearch = [];
    if (value == '') {
      emit(SearchUsersSuccess());
    } else {
      DioApp.getData(url: "${AppUrl.searchuser}/$value").then((value) {
        value.data.forEach((element) {
          userssearch.add(UserModel.fromJson(element));
        });
        emit(SearchUsersSuccess());
      });
    }
  }
}
