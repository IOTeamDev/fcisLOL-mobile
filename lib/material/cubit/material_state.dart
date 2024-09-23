import 'package:lol/material/cubit/material_cubit.dart';
import 'package:meta/meta.dart';

import '../model/material_model.dart';

@immutable
abstract class MaterialCubitState {}

class Material1Initial extends MaterialCubitState {}

class MaterialInitial extends MaterialCubitState {}

class GetMaterialLoading extends MaterialCubitState {}

class GetMaterialLoaded extends MaterialCubitState {
  final List<MaterialModel> materials;

  GetMaterialLoaded({required this.materials});
}

class GetMaterialError extends MaterialCubitState {
  final String errorMessage;

  GetMaterialError({required this.errorMessage});
}

class SaveMaterialLoading extends MaterialCubitState {}

class SaveMaterialSuccess extends MaterialCubitState {
  final MaterialModel material;

  SaveMaterialSuccess({required this.material});
}

class SaveMaterialError extends MaterialCubitState {
  final String errorMessage;

  SaveMaterialError({required this.errorMessage});
}
