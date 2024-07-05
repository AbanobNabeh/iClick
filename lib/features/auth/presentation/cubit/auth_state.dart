part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class UnFouceChange extends AuthState {}

class ChangeMailstate extends AuthState {}

class EmailUsedState extends AuthState {}

class VerifyEmailLoading extends AuthState {}

class VerifyEmailSuccess extends AuthState {}

class ChangeObscureState extends AuthState {}

class SignUpLoading extends AuthState {}

class SignUpSuccess extends AuthState {}

class OTPVaildState extends AuthState {}

class CheckEmailLoading extends AuthState {}

class EmailNotUsedState extends AuthState {}

class CheckEmailSuccess extends AuthState {}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {}

class SignInSuccess extends AuthState {}

class LoginError extends AuthState {}

class SignInLoading extends AuthState {}
