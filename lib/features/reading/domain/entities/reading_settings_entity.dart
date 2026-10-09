import 'package:equatable/equatable.dart';

class ReadingSettingsEntity extends Equatable {
  final int fontSize;

  const ReadingSettingsEntity({this.fontSize = 20});

  @override
  List<Object> get props => [fontSize];
}
