part of 'get_material_cubit_cubit.dart';

@immutable
sealed class GetMaterialState {}

final class GetMaterialInitial extends GetMaterialState {}

final class GetMaterialLoading extends GetMaterialState {}

final class GetMaterialSuccess extends GetMaterialState {}

final class GetMaterialError extends GetMaterialState {
  final String errorMessage;

  GetMaterialError({required this.errorMessage});
}

final class DeleteMaterialLoading extends GetMaterialState {}

final class DeleteMaterialSuccess extends GetMaterialState {}

final class DeleteMaterialError extends GetMaterialState {
  final String error;

  DeleteMaterialError({required this.error});
}
