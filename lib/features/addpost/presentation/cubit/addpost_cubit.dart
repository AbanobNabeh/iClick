import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/dionotification.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/features/addpost/presentation/widgets/editwid.dart';
import 'package:iclick/features/addpost/presentation/widgets/gallarywid.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
part 'addpost_state.dart';

class AddpostCubit extends Cubit<AddpostState> {
  AddpostCubit() : super(AddpostInitial());
  static AddpostCubit get(context) => BlocProvider.of(context);
  List<Widget> images = [];
  List<File> path = [];
  List<AssetEntity> videos = [];
  File? videofile;
  File? filee;
  int currentPage = 0;
  int? lastPage;
  int indexx = 0;
  final caption = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  DragableWidget? drag;
  bool isopacityLayer = false;
  double opacityLayer = 0;
  int type = 0;
  List<AssetEntity> media = [];
  Uint8List? postimage;

  void getimages() async {
    emit(GetImageLoading());
    type = 0;
    lastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      PhotoManager.getAssetPathList(type: RequestType.image).then((album) {
        album[0].getAssetListPaged(page: 0, size: 60).then((media) async {
          images = [];
          path = [];
          for (var asset in media) {
            if (asset.type == AssetType.image) {
              final file = await asset.file;
              if (file != null) {
                path.add(File(file.path));
                List<int> bytes = await path[0].readAsBytes();
                Uint8List uint8list = Uint8List.fromList(bytes);
                postimage = uint8list;
              }
            }

            images.add(itemgallery(asset));
          }
          emit(GetImageSuccess());
        });
      });
    }
  }

  void changeimage(int index) async {
    List<int> bytes = await path[index].readAsBytes();
    Uint8List uint8list = Uint8List.fromList(bytes);
    indexx = index;
    type == 0 ? postimage = uint8list : filee = path[index];
    emit(ChangeImageState());
  }

  void addtext(DragableWidget dragableWidgetTextChild, BuildContext context) {
    drag = dragableWidgetTextChild;
    emit(AddTextState());
  }

  Future<void> saveImage(Uint8List imageBytes, BuildContext context) async {
    final result = await ImageGallerySaver.saveImage(imageBytes);
    if (result != null) {
      Components.successmessage(
          context: context, message: "The image has been saved successfully");
    } else {
      print('Failed to save image');
    }
  }

  void changeopacity(double opacity) {
    opacityLayer = opacity;
    emit(ChangeOpacityState());
  }

  void offopacity() {
    isopacityLayer = !isopacityLayer;
    emit(ChangeOpacityState());
  }

  void shareImage(Uint8List imageBytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/image.jpg');
    await file.writeAsBytes(imageBytes);
    Share.shareXFiles(
      [XFile(file.path)],
    );
  }

  Future<void> cropImage(BuildContext context) async {
    final croppedImage = await ImageCropper().cropImage(
        sourcePath: filee!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              statusBarColor: AppColors.black,
              toolbarTitle: "Image Cropper",
              cropGridColor: AppColors.primary,
              cropFrameColor: AppColors.primary,
              activeControlsWidgetColor: AppColors.primary,
              dimmedLayerColor: AppColors.black,
              toolbarColor: AppColors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedImage != null) {
      filee = File(croppedImage.path);
      emit(ChangeImageState());
    }
  }

  void getvideos() async {
    emit(GetVideosLoading());
    type = 2;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      PhotoManager.getAssetPathList(type: RequestType.video).then((value) {
        value[0].getAssetListPaged(page: 0, size: 60).then((value) async {
          videos = [];
          value.forEach((element) async {
            videos.add(element);
          });
          emit(GetVideosSuccess());
        });
      });
    }
  }

  void getmedia() async {
    emit(GetMediaLoading());
    type = 1;
    lastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      PhotoManager.getAssetPathList(type: RequestType.all).then((album) {
        album[0]
            .getAssetListPaged(page: currentPage, size: 60)
            .then((mediaa) async {
          media = [];
          for (var asset in mediaa) {
            media.add(asset);
          }
          emit(GetMediaSuccess());
        });
      });
    }
  }

  void uploadStory(BuildContext context, int indexstory,
      {Uint8List? imageBytes, String? video}) async {
    emit(UploadStoryLoading());
    FormData formData = FormData.fromMap({
      'file': indexstory == 0
          ? MultipartFile.fromBytes(
              Uint8List.fromList(imageBytes!),
              filename: 'image.jpg',
            )
          : await MultipartFile.fromFile(video!),
      "image": indexstory
    });
    DioApp.postimg(url: AppUrl.uploadstory, data: formData).then((value) {
      if (value.data['status'] == "true") {
        Navigator.pop(context);
        Components.successmessage(
            context: context,
            message: 'The story has been successfully uploaded');
      }
      emit(UploadStorySuccess());
    });
  }

  void initvideo(File videofile, VideoPlayerController controller) {
    controller.setLooping(false);
    controller.setVolume(1.0);
    controller.play();
  }

  void uploadreel(BuildContext context) async {
    emit(UploadReelLoading());
    UserModel mydata = SplachscreenCubit.get(context).profile!;
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(videofile!.path),
      "caption": caption.text
    });
    DioApp.postimg(url: AppUrl.uploadreel, data: formData).then((value) {
      if (value.data['status'] == "true") {
        APInotification.sendnotifitopic(
            topic: "USER${mydata.id.toString()}",
            title: "${mydata.firstname} ${mydata.lastname}",
            body: "Add New Reel",
            type: "reel",
            link: value.data['data']['id'].toString());
        Navigator.pop(context);
        Components.successmessage(
            context: context,
            message: 'The Reel has been successfully uploaded');
      }
      emit(UploadReelSuccess());
    });
  }

  void uploadpost(BuildContext context) async {
    emit(UploadPostLoading());
    UserModel mydata = SplachscreenCubit.get(context).profile!;
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        Uint8List.fromList(postimage!),
        filename: 'image.jpg',
      )
    });
    DioApp.postimg(url: AppUrl.uploadpost, data: formData).then((value) {
      if (value.data['status'] == "true") {
        APInotification.sendnotifitopic(
            topic: "USER${mydata.id.toString()}",
            title: "${mydata.firstname} ${mydata.lastname}",
            body: "Add New Post",
            type: "post",
            link: value.data['date']['id'].toString());
        Navigator.pop(context);
        Components.successmessage(
            context: context,
            message: 'The Post has been successfully uploaded');
      }
      emit(UploadPostSuccess());
    });
  }

  void applyedit(
    Uint8List uint8list,
  ) async {
    postimage = Uint8List.fromList(uint8list);
    emit(ApplyEditState());
  }
}
