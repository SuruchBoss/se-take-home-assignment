import 'package:equatable/equatable.dart';
import '../model/menu_item.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> menuItems;
  final List<MenuItem> cartItems;
  final int userQueue;
  final int currentQueue;

  const MenuLoaded(this.menuItems, this.cartItems, this.userQueue, this.currentQueue);

  @override
  List<Object> get props => [menuItems, cartItems, userQueue, currentQueue];
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object> get props => [message];
}
