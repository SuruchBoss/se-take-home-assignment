part of 'bot_cubit.dart';

abstract class BotState {
  final int numberOfBots;

  const BotState(this.numberOfBots);
}

class BotInitial extends BotState {
  const BotInitial(super.numberOfBots);
}
