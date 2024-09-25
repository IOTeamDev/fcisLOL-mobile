part of 'subject_cubit.dart';

@immutable
sealed class SubjectState {}

final class Material1Initial extends SubjectState {}

final class MaterialInitial extends SubjectState {}

final class GetMaterialLoading extends SubjectState {}

final class GetMaterialLoaded extends SubjectState {
  final List<MaterialModel> materials;

  GetMaterialLoaded({required this.materials});
}

final class GetMaterialError extends SubjectState {
  final String errorMessage;

  GetMaterialError({required this.errorMessage});
}

final class SaveMaterialLoading extends SubjectState {}

final class SaveMaterialSuccess extends SubjectState {}

final class SaveMaterialError extends SubjectState {
  final String errorMessage;

  SaveMaterialError({required this.errorMessage});
}
