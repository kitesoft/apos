import 'package:apos/src/models/menuModels.dart';

abstract class MenuState {}

class MenuInitialized extends MenuState {}

class MenuEmpty extends MenuState {}

class MenuLoading extends MenuState {}

class MenuError extends MenuState {}

class MenuLoaded extends MenuState {
  List<Menu> foods;
  List<Menu> drinks;
  MenuLoaded({this.foods, this.drinks});
}

class MenuAddLoading extends MenuState {}

class MenuAddInitialized extends MenuState {}

class MenuAddError extends MenuState {}

class MenuAddSuccess extends MenuState {}

class MenuAddFailed extends MenuState {
  final String message;
  MenuAddFailed({this.message});
}



