part of 'delete_material_cubit.dart';

@immutable
sealed class DeleteMaterialState {}

final class DeleteMaterialInitial extends DeleteMaterialState {}

class DeleteMaterialLoading extends DeleteMaterialState {}

class DeleteMaterialSuccess extends DeleteMaterialState {}

final class DeleteMaterialError extends DeleteMaterialState {
  final String error;

  DeleteMaterialError({required this.error});
}
