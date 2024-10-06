part of 'subject_cubit.dart';

@immutable
sealed class SubjectState {}

final class MaterialInitial extends SubjectState {}

final class GetMaterialLoading extends SubjectState {}

final class GetMaterialSuccess extends SubjectState {
  final List<MaterialModel> materials;

  GetMaterialSuccess({required this.materials});
}

final class GetMaterialError extends SubjectState {
  final String errorMessage;

  GetMaterialError({required this.errorMessage});
}

final class SaveMaterialLoading extends SubjectState {}

final class SaveMaterialSuccessAdmin extends SubjectState {}

final class SaveMaterialSuccessUser extends SubjectState {}

final class SaveMaterialError extends SubjectState {
  final String errorMessage;

  SaveMaterialError({required this.errorMessage});
}

class DeleteMaterialLoading extends SubjectState {}

class DeleteMaterialSuccess extends SubjectState {}

final class DeleteMaterialError extends SubjectState {
  final String error;

  DeleteMaterialError({required this.error});
}

final class TabChangedState extends SubjectState {
  final int selectedIndex;

  TabChangedState({required this.selectedIndex});
}

final class TypeChangedState extends SubjectState {
  final String selectedType;

  TypeChangedState({required this.selectedType});
}
