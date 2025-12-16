import 'package:flutter_bloc/flutter_bloc.dart';
import '../../menu/model/menu_item.dart';
import '../model/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartLoaded([]));

  void addToCart(MenuItem menuItem) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final List<CartItem> updatedCart = List.from(currentState.cartItems);
      
      final index = updatedCart.indexWhere((item) => item.menuItem.id == menuItem.id);

      if (index != -1) {
        // Item already in cart, increase quantity
        final existingItem = updatedCart[index];
        updatedCart[index] = existingItem.copyWith(quantity: existingItem.quantity + 1);
      } else {
        // Add new item
        updatedCart.add(CartItem(menuItem: menuItem));
      }
      emit(CartLoaded(updatedCart));
    }
  }

  void removeFromCart(CartItem cartItem) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final List<CartItem> updatedCart = List.from(currentState.cartItems)
        ..remove(cartItem);
      emit(CartLoaded(updatedCart));
    }
  }

  void incrementQuantity(CartItem cartItem) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final List<CartItem> updatedCart = List.from(currentState.cartItems);
      final index = updatedCart.indexWhere((item) => item.menuItem.id == cartItem.menuItem.id);
      if (index != -1) {
        final existingItem = updatedCart[index];
        updatedCart[index] = existingItem.copyWith(quantity: existingItem.quantity + 1);
        emit(CartLoaded(updatedCart));
      }
    }
  }

  void decrementQuantity(CartItem cartItem) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final List<CartItem> updatedCart = List.from(currentState.cartItems);
      final index = updatedCart.indexWhere((item) => item.menuItem.id == cartItem.menuItem.id);
      if (index != -1) {
        final existingItem = updatedCart[index];
        if (existingItem.quantity > 1) {
          updatedCart[index] = existingItem.copyWith(quantity: existingItem.quantity - 1);
          emit(CartLoaded(updatedCart));
        } else {
          // If quantity is 1, remove the item
          removeFromCart(cartItem);
        }
      }
    }
  }
}
