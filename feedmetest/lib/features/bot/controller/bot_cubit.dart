import 'package:flutter_bloc/flutter_bloc.dart';

part 'bot_state.dart';

class BotCubit extends Cubit<BotState> {
  BotCubit() : super(const BotInitial(1));

  void setNumberOfBots(int count) {
    emit(BotInitial(count));
  }
}
