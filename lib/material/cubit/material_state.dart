part of 'material_cubit.dart';

@immutable
sealed class MaterialState {}

final class Material1Initial extends MaterialState {}

final class MaterialInitial extends MaterialState {}

final class GetMaterialLoading extends MaterialState {}

final class GetMaterialLoaded extends MaterialState {
  final List<material_model.MaterialModel> materials;

  GetMaterialLoaded({required this.materials});
}

final class GetMaterialError extends MaterialState {
  final String errorMessage;

  GetMaterialError({required this.errorMessage});
}

final class SaveMaterialLoading extends MaterialState {}

final class SaveMaterialSuccess extends MaterialState {
  final material_model.MaterialModel material;

  SaveMaterialSuccess({required this.material});
}

final class SaveMaterialError extends MaterialState {
  final String errorMessage;

  SaveMaterialError({required this.errorMessage});
}
