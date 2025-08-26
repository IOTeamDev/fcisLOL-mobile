part of 'pick_image_cubit.dart';

@immutable
sealed class PickImageState {}

final class PickImageInitial extends PickImageState {}

final class UploadImageLoading extends PickImageState {}

final class UploadImageSuccess extends PickImageState {
  final String imageUrl;

  UploadImageSuccess({required this.imageUrl});
}

final class UploadImageFailed extends PickImageState {
  final String errMessage;

  UploadImageFailed({required this.errMessage});
}

final class UpdateUserImageLoading extends PickImageState {}

final class UpdateUserImageSuccess extends PickImageState {}

final class UpdateUserImageFailed extends PickImageState {
  final String errMessage;

  UpdateUserImageFailed({required this.errMessage});
}
