import 'package:equatable/equatable.dart';
import 'package:feedmetest/features/cart/model/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  const CartLoaded(this.cartItems);

  @override
  List<Object> get props => [cartItems];

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.menuItem.price * item.quantity));
}
