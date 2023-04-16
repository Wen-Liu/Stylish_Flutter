part of '../ui/home_page/get_product_list_cubit.dart';

@immutable
abstract class ApiState {}

class Loading extends ApiState {}

class ApiSuccess<T> extends ApiState {
  final T data;

  ApiSuccess(this.data);
}

class ApiError extends ApiState {
  final String errorCode;

  ApiError(this.errorCode);
}
