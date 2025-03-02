part of 'add_material_cubit.dart';

@immutable
sealed class AddMaterialState {}

final class AddMaterialInitial extends AddMaterialState {}

final class AddMaterialLoading extends AddMaterialState {}

final class AddMaterialSuccessAdmin extends AddMaterialState {}

final class AddMaterialSuccessUser extends AddMaterialState {}

final class AddMaterialFailed extends AddMaterialState {
  final String errorMessage;

  AddMaterialFailed({required this.errorMessage});
}

final class TypeChangedState extends AddMaterialState {
  final String selectedType;

  TypeChangedState({required this.selectedType});
}

final class EditMaterialLoading extends AddMaterialState {}

final class EditMaterialSuccess extends AddMaterialState {}

final class EditMaterialFailed extends AddMaterialState {
  final String errorMessage;

  EditMaterialFailed({required this.errorMessage});
}
