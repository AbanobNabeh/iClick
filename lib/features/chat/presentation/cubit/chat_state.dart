part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class GetProfileUserLoading extends ChatState {}

class GetProfileUserSuccess extends ChatState {}

class ChangeStateEmoji extends ChatState {}

class SendMessageLoading extends ChatState {}

class SendMessageSuccess extends ChatState {}

class GetMessageLoading extends ChatState {}

class GetMessageSuccess extends ChatState {}

class GetChatListLoading extends ChatState {}

class GetChatListSuccess extends ChatState {}

class ImageSuccess extends ChatState {}

class ImageError extends ChatState {}

class GetImagesMediaLoading extends ChatState {}

class GetImagesMediaSuccess extends ChatState {}

class GetVideosMediaLoading extends ChatState {}

class GetVideosMediaSuccess extends ChatState {}

class GetFilesMediaLoading extends ChatState {}

class GetFilesMediaSuccess extends ChatState {}

class ChangeTimeMuteState extends ChatState {}

class ChangeMenuMuteState extends ChatState {}

class CheckMuteState extends ChatState {}

class DeleteChatLoading extends ChatState {}

class DeleteChatSuccess extends ChatState {}

class CheckBlockState extends ChatState {}

class BlockUserLoading extends ChatState {}

class BlockUserSuccess extends ChatState {}
