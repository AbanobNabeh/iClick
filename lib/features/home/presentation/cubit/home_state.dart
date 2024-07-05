part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class ChangeIndexState extends HomeState {}

class ImageSuccess extends HomeState {}

class ImageError extends HomeState {}

class GetStoriesLoading extends HomeState {}

class GetStoriesSuccess extends HomeState {}

class GetPostsLoading extends HomeState {}

class LoadMorePosts extends HomeState {}

class GetPostsSuccess extends HomeState {}

class GetViewersLoading extends HomeState {}

class GetViewersSuccess extends HomeState {}

class ChangeIconHomeState extends HomeState {}

class ScrollLoaddata extends HomeState {}

class IsReplayState extends HomeState {}

class AddCommentLoading extends HomeState {}

class AddCommentSuccess extends HomeState {}

class GetCommentLoading extends HomeState {}

class GetCommentSuccess extends HomeState {}

class AddReplayLoading extends HomeState {}

class AddReplaySuccess extends HomeState {}

class GetReplayLoading extends HomeState {}

class GetReplaySuccess extends HomeState {}

class LikeCommentLoading extends HomeState {}

class LikeCommentSuccess extends HomeState {}

class LikeReplayLoading extends HomeState {}

class LikeReplaySuccess extends HomeState {}

class DeleteReplay extends HomeState {}

class LikeReelLoading extends HomeState {}

class LikeReelSuccess extends HomeState {}

class UnLikeReelSuccess extends HomeState {}

class GetPostIDLoading extends HomeState {}

class GetPostIDSuccess extends HomeState {}

class FollowUserState extends HomeState {}

class SearchUsersLoading extends HomeState {}

class SearchUsersSuccess extends HomeState {}
