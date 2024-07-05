part of 'noification_cubit.dart';

abstract class NotificationState {}

class NoificationInitial extends NotificationState {}

class GetNotifiyLoading extends NotificationState {}

class GetNotifiySuccess extends NotificationState {}

class SeenNotifiyLoading extends NotificationState {}

class SeenNotifiySuccess extends NotificationState {}
