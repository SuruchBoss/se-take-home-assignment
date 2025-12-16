
import 'package:feedmetest/features/cart/controller/cart_cubit.dart';
import 'package:feedmetest/features/cart/controller/cart_state.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_cubit.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_state.dart';
import 'package:feedmetest/features/menu/controller/menu_cubit.dart';
import 'package:feedmetest/features/menu/controller/menu_state.dart';
import 'package:feedmetest/features/menu/presentation/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockMenuCubit extends Mock implements MenuCubit {}

class MockCartCubit extends Mock implements CartCubit {}

class MockKitchenCubit extends Mock implements KitchenCubit {}

void main() {
  late MockMenuCubit mockMenuCubit;
  late MockCartCubit mockCartCubit;
  late MockKitchenCubit mockKitchenCubit;

  setUp(() {
    mockMenuCubit = MockMenuCubit();
    mockCartCubit = MockCartCubit();
    mockKitchenCubit = MockKitchenCubit();
  });

  testWidgets('MenuScreen manager mode toggles correctly',
      (WidgetTester tester) async {
    when(mockMenuCubit.state).thenReturn(MenuLoaded(const []));
    when(mockCartCubit.state).thenReturn(CartLoaded(const []));
    when(mockKitchenCubit.state).thenReturn(KitchenInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<MenuCubit>.value(value: mockMenuCubit),
            BlocProvider<CartCubit>.value(value: mockCartCubit),
            BlocProvider<KitchenCubit>.value(value: mockKitchenCubit),
          ],
          child: const MenuScreen(),
        ),
      ),
    );

    // Initial state: not manager
    expect(find.byIcon(Icons.admin_panel_settings_outlined), findsOneWidget);
    expect(find.byIcon(Icons.admin_panel_settings), findsNothing);

    // Tap 5 times to become manager
    for (int i = 0; i < 5; i++) {
      await tester.tap(find.byIcon(Icons.admin_panel_settings_outlined));
      await tester.pump();
    }

    //
    await tester.pumpAndSettle();

    // Verify manager mode
    expect(find.text('You are now a Manager'), findsOneWidget);
    expect(find.byIcon(Icons.admin_panel_settings_outlined), findsNothing);
    expect(find.byIcon(Icons.admin_panel_settings), findsOneWidget);

    // Tap 5 times to log out of manager
    for (int i = 0; i < 5; i++) {
      await tester.tap(find.byIcon(Icons.admin_panel_settings));
      await tester.pump();
    }
    await tester.pumpAndSettle();

    // Verify logged out state
    expect(find.text('You are no longer a Manager'), findsOneWidget);
    expect(find.byIcon(Icons.admin_panel_settings_outlined), findsOneWidget);
    expect(find.byIcon(Icons.admin_panel_settings), findsNothing);
  });
}
