import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/menu_item.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuInitial());

  final List<MenuItem> _menuItems = [
    MenuItem(
      id: '1',
      name: 'Burger',
      price: 5.99,
      imageUrl:
          'https://www.foodandwine.com/thmb/0SHv4wzGz7OBOcYtVbRWQeuR2CQ=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/MSG-Smash-Burger-FT-RECIPE0124-d9682401f3554ef683e24311abdf342b.jpg',
    ),
    MenuItem(
      id: '2',
      name: 'Pizza',
      price: 8.99,
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1673439304183-8840bd0dc1bf?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    MenuItem(
      id: '3',
      name: 'Salad',
      price: 4.99,
      imageUrl:
          'https://images.pexels.com/photos/1059905/pexels-photo-1059905.jpeg',
    ),
    MenuItem(
      id: '4',
      name: 'Fries',
      price: 2.99,
      imageUrl:
          'https://images.pexels.com/photos/1586942/pexels-photo-1586942.jpeg',
    ),
  ];

  final List<MenuItem> _cartItems = [];

  void getMenuItems() {
    emit(MenuLoading());
    // In a real app, you would fetch this from an API
    emit(MenuLoaded(List.from(_menuItems), List.from(_cartItems), 123, 120));
  }

  void addToCart(MenuItem item) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      _cartItems.add(item);
      emit(
        MenuLoaded(List.from(currentState.menuItems), List.from(_cartItems), currentState.userQueue, currentState.currentQueue),
      );
    }
  }
}
