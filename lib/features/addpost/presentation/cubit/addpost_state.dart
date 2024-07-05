part of 'addpost_cubit.dart';

abstract class AddpostState {}

class AddpostInitial extends AddpostState {}

class GetMediaLoading extends AddpostState {}

class GetMediaSuccess extends AddpostState {}

class ChangeImageState extends AddpostState {}

class AddTextState extends AddpostState {}

class ChangeOpacityState extends AddpostState {}

class ImageCroppedState extends AddpostState {}

class GetVideosLoading extends AddpostState {}

class GetVideosSuccess extends AddpostState {}

class GetImageLoading extends AddpostState {}

class GetImageSuccess extends AddpostState {}

class DesposeState extends AddpostState {}

class UploadStoryLoading extends AddpostState {}

class UploadStorySuccess extends AddpostState {}

class UploadReelLoading extends AddpostState {}

class UploadReelSuccess extends AddpostState {}

class UploadPostSuccess extends AddpostState {}

class UploadPostLoading extends AddpostState {}

class ApplyEditState extends AddpostState {}
