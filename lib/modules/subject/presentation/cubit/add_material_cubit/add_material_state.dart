part of 'add_material_cubit.dart';

@immutable
sealed class AddMaterialState {}

final class AddMaterialInitial extends AddMaterialState {}

final class AddMaterialLoading extends AddMaterialState {}

final class AddMaterialSuccessAdmin extends AddMaterialState {}

final class AddMaterialSuccessUser extends AddMaterialState {}

final class AddMaterialError extends AddMaterialState {
  final String errorMessage;

  AddMaterialError({required this.errorMessage});
}
