part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class GetProfileUserLoading extends ProfileState {}

class GetProfileUserSuccess extends ProfileState {}

class GetPostsUserLoading extends ProfileState {}

class GetPostsUserSuccess extends ProfileState {}

class ChangeIndexState extends ProfileState {}

class FollowUserLoading extends ProfileState {}

class FollowUserSuccess extends ProfileState {}

class GetReelsUserLoading extends ProfileState {}

class GetReelsUserSuccess extends ProfileState {}

class ImageSuccess extends ProfileState {}

class ImageError extends ProfileState {}

class RefrashState extends ProfileState {}

class EditProfileLoading extends ProfileState {}

class EditProfileSuccess extends ProfileState {}

class ChangeOTPState extends ProfileState {}

class ChangeObscureState extends ProfileState {}

class ResetPasswordLoading extends ProfileState {}

class ResetPasswordSuccess extends ProfileState {}

class StartTimerOTP extends ProfileState {}

class SendOTPLoading extends ProfileState {}
