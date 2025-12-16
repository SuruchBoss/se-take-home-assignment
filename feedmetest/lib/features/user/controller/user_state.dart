import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final bool isVip;

  const UserState({this.isVip = false});

  @override
  List<Object> get props => [isVip];
}
